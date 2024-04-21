defmodule Cen.ApplicantsTest do
  use Cen.DataCase

  alias Cen.AccountsFixtures
  alias Cen.Applicants

  describe "cvs" do
    import Cen.ApplicantsFixtures

    alias Cen.Applicants.CV

    setup context do
      Map.put(context, :invalid_attrs, %{
        summary: nil,
        published: nil,
        reviewed: nil,
        employment_types: nil,
        work_schedules: nil,
        field_of_art: nil,
        years_of_work_experience: nil,
        applicant: AccountsFixtures.user_fixture()
      })
    end

    test "list_cvs/0 returns all cvs" do
      cv = cv_fixture()
      assert Applicants.list_cvs() == [cv]
    end

    test "get_cv!/1 returns the cv with given id" do
      cv = cv_fixture()
      assert Applicants.get_cv!(cv.id) == cv
    end

    test "create_cv/1 with valid data creates a cv" do
      valid_attrs = %{
        title: "some title",
        summary: "some summary",
        published: true,
        reviewed: true,
        employment_types: [:main],
        work_schedules: [:full_time, :part_time],
        field_of_art: :folklore,
        years_of_work_experience: 42,
        applicant: AccountsFixtures.user_fixture()
      }

      assert {:ok, %CV{} = cv} = Applicants.create_cv(valid_attrs)
      assert cv.title == "some title"
      assert cv.summary == "some summary"
      assert cv.published == true
      assert cv.reviewed == true
      assert cv.employment_types == [:main]
      assert cv.work_schedules == [:full_time, :part_time]
      assert cv.field_of_art == :folklore
      assert cv.years_of_work_experience == 42
    end

    test "create_cv/1 with invalid data returns error changeset", %{invalid_attrs: invalid_attrs} do
      assert {:error, %Ecto.Changeset{}} = Applicants.create_cv(invalid_attrs)
    end

    test "update_cv/2 with valid data updates the cv" do
      cv = cv_fixture()

      update_attrs = %{
        title: "some updated title",
        summary: "some updated summary",
        published: false,
        employment_types: [:secondary, :internship],
        work_schedules: [:flexible_schedule],
        field_of_art: :music,
        years_of_work_experience: 43,
        applicant: AccountsFixtures.user_fixture()
      }

      assert {:ok, %CV{} = cv} = Applicants.update_cv(cv, update_attrs)
      assert cv.summary == "some updated summary"
      assert cv.published == false
      assert cv.employment_types == [:secondary, :internship]
      assert cv.work_schedules == [:flexible_schedule]
      assert cv.field_of_art == :music
      assert cv.years_of_work_experience == 43
    end

    test "update_cv/2 with invalid data returns error changeset", %{invalid_attrs: invalid_attrs} do
      cv = cv_fixture()
      assert {:error, %Ecto.Changeset{}} = Applicants.update_cv(cv, invalid_attrs)
      assert cv == Applicants.get_cv!(cv.id)
    end

    test "delete_cv/1 deletes the cv" do
      cv = cv_fixture()
      assert {:ok, %CV{}} = Applicants.delete_cv(cv)
      assert_raise Ecto.NoResultsError, fn -> Applicants.get_cv!(cv.id) end
    end
  end
end
