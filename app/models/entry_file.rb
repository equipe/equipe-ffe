class EntryFile

  def initialize(content)
    @doc = Nokogiri::XML(content)
  end

  def import
    organizer
    show
    competitions
    officials
    reset_index
    riders
    horses
    entries
  end

  def valid?
    doc.root&.name == 'message' && doc.root&.namespace&.prefix == 'ffe'
  end

  def show
    @show ||= fetch_show
  end

  private

  attr_reader :doc, :rider_index, :horse_index

  DISCIPLINE = {
    '01' => 'H',
    '03' => 'D'
  }

  SEX = {
    'M' => 'S',
    'F' => 'M',
    'H' => 'G'
  }

  def organizer
    @organizer ||= Organizer.where(ffe_id: organizer_id).first_or_create(name: organizer_name)
  end

  def organizer_id
    doc.css('concours > organisateur').attr('num').value
  end

  def organizer_name
    doc.css('concours > organisateur').attr('nom').value.mb_chars.titlecase
  end

  def fetch_show
    organizer.shows.where(ffe_id: show_id).first_or_create(name: show_name, starts_on: dates.first, ends_on: dates.last)
  end

  def show_id
    doc.css('concours').attr('num').value
  end

  def show_name
    doc.css('concours').attr('nom').value.mb_chars.titlecase
  end

  def discipline
    @discipline ||= DISCIPLINE[doc.css('concours').attr('discipline').value]
  end

  def dates
    @dates ||= doc.css('concours > epreuve').map { |item| item['date'] }.uniq.sort
  end

  def competitions
    doc.css('concours > epreuve').each do |item|
      competition = show.competitions.where(competition_no: item['num']).first_or_initialize
      competition.starts_on = item['date']
      competition.name = item['nom_categorie']
      competition.discipline = discipline
      competition.late_entry_fee = item['montant_eng_terrain']
      competition.judgement_id = item['nom_categorie']
      competition.save!
    end
  end

  def officials
    doc.css('officiel').each do |officiel|
      official = Person.where(licence: officiel['lic']).first_or_initialize
      official.first_name = officiel['prenom'].mb_chars.titlecase
      official.last_name = officiel['nom'].mb_chars.titlecase
      official.official = true
      official.save!
    end
  end

  def reset_index
    @rider_index = {}
    @horse_index = {}
  end

  def riders
    doc.css('cavalier').each do |cavalier|
      rider = Person.where(licence: cavalier['lic']).first_or_initialize
      rider.first_name = cavalier['prenom'].mb_chars.titlecase
      rider.last_name = cavalier['nom'].mb_chars.titlecase
      rider.club = Club.where(ffe_id: cavalier['club']).first_or_create(name: cavalier['nom_club'].mb_chars.titlecase)
      rider.birthday = cavalier['dnaiss']
      rider.region = Region.where(ffe_id: cavalier['region']).first_or_create(name: cavalier['nom_region'])
      rider.save!
      rider_index[cavalier['lic']] = rider.id
      rider
    end
  end

  def horses
    doc.css('equide').each do |equide|
      horse = Horse.where(licence: equide['sire']).first_or_initialize
      horse.name = Equipe::HorseName.new(equide['nom']).normalize
      horse.height = equide['taille']
      horse.race = equide['race']
      horse.breed = equide['code_race'].mb_chars.titlecase
      horse.color = equide['code_robe']
      horse.born_year = equide['dnaiss'].to_s.split('-').first
      horse.chip_no = equide['transpondeur']
      horse.sex = SEX[equide['sexe']]
      horse.sire = Equipe::HorseName.new(equide.css('> pere').attr('nom').value).normalize if equide.css('> pere').present?
      horse.dam = Equipe::HorseName.new(equide.css('mere').attr('nom').value).normalize if equide.css('mere').present?
      horse.dam_sire = Equipe::HorseName.new(equide.css('> mere pere').attr('nom').value).normalize if equide.css('> mere pere').present?
      horse.save!
      horse_index[equide['sire']] = horse.id
      horse
    end
  end

  def entries
    doc.css('epreuve > engagement').each do |engagement|
      rider_licence = engagement.at_css('cavalier').attr('lic')
      horse_licence = engagement.at_css('equide').attr('sire')

      entry = Entry.where(ffe_id: engagement['id']).first_or_initialize
      entry.competition = show.competitions.find_by(competition_no: engagement.parent['num'])
      entry.start_no = engagement['dossard']
      entry.rider_id = rider_index[rider_licence]
      entry.horse_id = horse_index[horse_licence]
      entry.save!
    end
  end

end