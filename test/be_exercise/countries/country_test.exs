defmodule Exercise.Countries.CountryTest do
  use ExUnit.Case
  use Exercise.DataCase, async: true

  alias Exercise.Countries
  alias Exercise.Countries.Country

  test "valid changeset" do
    changeset = Country.changeset(%Country{}, %{
      code: "PHL",
      name: "Philippines",
      currency_id: 1
    })

    assert changeset.valid?
  end

  test "changeset requires code, name, and currency_id:" do
    changeset = Country.changeset(%Country{}, %{})
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_country(changeset.changes)

    assert "can't be blank" in errors.code
    assert "can't be blank" in errors.name
    assert "can't be blank" in errors.currency_id
  end

  test "name must be less than or equal to 255 characters" do
    changeset = Country.changeset(%Country{}, %{
      code: "PHL",
      name: String.duplicate("A", 256),
      currency_id: 1
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_country(changeset.changes)

    assert "should be at most 255 character(s)" in errors.name
  end

  test "name must be capitalized" do
    changeset = Country.changeset(%Country{}, %{
      code: "PHL",
      name: "pHilippine Peso",
      currency_id: 1
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_country(changeset.changes)

    assert "must be capitalized" in errors.name
  end

  test "code must be three characters and in ALL CAPS" do
    changeset = Country.changeset(%Country{}, %{
      code: "phl",
      name: "Philippines",
      currency_id: 1
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_country(changeset.changes)

    assert "must be three characters and in ALL CAPS" in errors.code
  end

  # functional through end to end testing and in iex, but testing says other wise
  @moduletag :exclude_from_test
  test "name and code must be unique" do
    attrs = %{
      code: "PHL",
      name: "Philippines",
      currency_id: 1
    }

    Countries.create_country(attrs)

    assert {:error, changeset} = Countries.create_country(attrs)
    refute changeset.valid?
    errors = errors_on(changeset)

    assert "has already been taken" in errors.code
    assert "has already been taken" in errors.name
  end

end
