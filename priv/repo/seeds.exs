# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cen.Repo.insert!(%Cen.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

employer =
  Cen.Repo.insert!(%Cen.Accounts.User{
    email: "username@domain.org",
    fullname: "Иванов Иван Иванович",
    # Password is "password-from-seed"
    hashed_password: "$2b$12$eQvcD.hsuKO9LxbDWTJx/.kY0qNuWIDEGiYkoH2xarWo7udRo8hba",
    role: :employer
  })

urfu_organization =
  Cen.Repo.insert!(%Cen.Employers.Organization{
    name: "УрФУ имени первого Президента России Б.Н. Ельцина",
    logo: "/uploads/urfu.png",
    description: "applicant",
    address: "620002, Свердловская область, г. Екатеринбург, ул. Мира, д. 19",
    contacts: "+78005553535",
    employer_id: employer.id
  })

Enum.each(
  [
    %Cen.Employers.Vacancy{
      published: true,
      reviewed: true,
      title: "Танцор под электронную музыку",
      description: "Нужно танцевать и прыгать. Много прыгать.",
      employment_type: :main,
      work_schedule: :full_time,
      education: :secondary,
      field_of_art: :choreography,
      min_years_of_work_experience: 5,
      proposed_salary: 40_000,
      organization_id: urfu_organization.id
    },
    %Cen.Employers.Vacancy{
      published: true,
      reviewed: true,
      title: "Пианист",
      description: "Нужно играть на пианино",
      employment_type: :secondary,
      work_schedule: :full_time,
      education: :higher,
      field_of_art: :music,
      min_years_of_work_experience: 5,
      proposed_salary: 37_000,
      organization_id: urfu_organization.id
    }
  ],
  &Cen.Repo.insert!/1
)
