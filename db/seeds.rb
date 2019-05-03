# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

nombres = [
  "Eduardo",
  "David",
  "Jose",
  "Pepde",
  "Luis",
  "Oscar",
  "Damian",
  "Luke",
  "Mikael",
  "Rebeca",
  "Marifer",
  "Ricardo",
  "Josue",
  "Daniel",
  "Mauricio",
  "Diego",
  "Hugo",
  "Harry",
  "Scorr",
  "Jorge",
  "Nicolas",
  "Fernanda",
  "Marcela",
  "Cordelia",
  "Ana",
  "Ana Lucia",
  "Lucia",
  "Fernanda",
  "Daniela",
  "Alicia",
  "Ana Paola",
  "Ivette",
  "Xuen",
  "Lisa",
  "Benedict",
  "Juth",
  "Pepper",
  "Maria",
  "Scarlett",
  "Liam",
  "Emma",
  "Noah",
  "Olivia",
  "William",
  "Ava",
  "James",
  "Isabella",
  "Logan",
  "Sophia",
  "Benjamin",
  "Mia",
  "Mason",
  "Charlotte",
  "Elijah",
  "Amelia",
  "Oliver",
  "Evelyn",
  "Jacob",
  "Abigail",
  "Lucas",
  "Harper",
  "Michael",
  "Emily",
  "Alexander",
  "Elizabeth",
  "Ethan",
  "Avery",
  "Daniel",
  "Sofia",
  "Matthew",
  "Ella",
  "Aiden",
  "Madison",
  "Herney",
  "Scarlett",
  "Joseph",
  "Victoria",
  "Jackson",
  "Victoria",
  "Aria",
  "Samuel",
  "Grace",
  "Sebastian",
  "Chloe",
  "David",
  "Camila",
  "Carter",
  "Penelope",
  "Wyatt",
  "Riley",
  "Jayden",
  "Layla",
  "John",
  "Lillian",
  "Owen",
  "Nora",
  "Dylan",
  "Zoey",
  "Luke",
  "Mila",
  "Gabriel",
  "Aubrey",
  "Anthony",
  "Hannah",
  "Isaac",
  "Lily",
  "Grayson",
  "Addison",
  "Jack",
  "Eleanor"
]

apeidos = [
  "Aguilar",
  "Leal",
  "Garcia",
  "Llaguno",
  "Belden",
  "Wiegers",
  "Flores",
  "Cantu",
  "Lara",
  "Martinez",
  "Parker",
  "Johanson",
  "Cumberpickle",
  "Pilgrim",
  "Garza",
  "Sanchez",
  "Law",
  "Ming",
  "Lee",
  "Ancer",
  "Gomez",
  "Torres",
  "Pontones",
  "Cantu",
  "Terrazas",
  "Peuyero",
  "Smith",
  "Johnson",
  "Williams",
  "Jones",
  "Brown",
  "Davis",
  "Miller",
  "Wilson",
  "Moore",
  "Taylor",
  "Anderson",
  "Thomas",
  "Jackson",
  "Hall",
  "Allen",
  "Young",
  "Hernandez",
  "King",
  "Wright",
  "Lopez",
  "Hill",
  "Scott",
  "Green",
  "Adams",
  "Baker",
  "Gonzalex",
  "Zuñiga",
  "Sewart",
  "Sanchez",
  "Morris",
  "Rogers",
  "Reed",
  "Cook",
  "Morgan",
  "Bell",
  "Murphy",
  "Bailey",
  "Rivera",
  "Cooper",
  "Richardson"
]

sexos = [
  "masculino",
  "femeninio"
]

sickness = [
  "flu",
  "cancer",
  "aids",
  "broken arm"
]

medicaments = [
  "sleep",
  "pain killers",
  "insulin",
  "aloe cream",
  "prayers",
  "arnica",
  "anti-biotics",
  "biseptol",
  "curam",
  "flanax",
  "Nisatin",
  "olfen",
  "pentrxyl",
  "primolut nor",
  "primperan",
  "propoven",
  "reglin",
  "ultran",
  "manalx",
  "amolez",
  "amotrip",
  "marihuana",
  "mizraba",
  "mokotam",
  "amotrip",
  "anpran",
  "antix",
  "moclodura",
  "pravastatine",
  "ciplox",
  "coproactin"
]

specialties = [
  "General Medicine",
  "Traumatology",
  "Allergology",
  "Radiology",
  "Cardiology",
  "Gerontology",
  "Obstetrics",
  "Pediatrics"
]
specialtiesNum = [0,1,2,3,4,5,6,7]

persons = []
doctors = []
areas = []

specialtiesNum.each do |num|
  area = Area.create(
    name: specialties[num],
    location: "somewhere",
    specialty: num
  )
  areas.append area
end

100.times do
  person = Person.create(
    firstName: nombres.sample,
    lastName: apeidos.sample,
    dob: "dob",
    gender: sexos.sample
  )
  persons.append person

  specialty = specialtiesNum.sample
  doctor = Doctor.create(
    person: person,
    specialty: specialty,
    yearsExperience: [1,2,3,4,5].sample,
    salary: 10000,
    area: areas[specialty]
  )
  doctors.append doctor
end

areas.each do |area|
  leader = area.doctors.sample
  if leader
    area.leader = leader
  end
end

500.times do
  person = Person.create(
    firstName: nombres.sample,
    lastName: apeidos.sample,
    dob: "dob",
    gender: sexos.sample
  )
  persons.append person

  insurance = [0,1,2].sample
  patient = Patient.create(
    person: person,
    insurancePlan: insurance
  )

  compatibleDoctors = []
  if insurance == 0
    compatibleDoctors = doctors.select do |doc|
      doc.specialty == 0 || doc.specialty == 6 || doc.specialty == 7
    end
  elsif insurance == 1
    compatibleDoctors = doctors.select do |doc|
      doc.specialty != 3
    end
  else
    compatibleDoctors = doctors
  end


  treatment = Treatment.create(
    patient: patient,
    doctor: compatibleDoctors.sample,
    duration: [1,2,3,7,7,7,30].sample,
    medicaments: [medicaments.sample, medicaments.sample],
    description: "take medicaments for duration"
  )

end
