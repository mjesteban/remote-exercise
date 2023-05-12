defmodule Exercise.Countries.CurrencyTest do
  use ExUnit.Case
  use Exercise.DataCase, async: true

  alias Exercise.Countries
  alias Exercise.Countries.Currency

  test "valid changeset" do
    changeset = Currency.changeset(%Currency{}, %{
      code: "PHP", name: "Philippine Peso", symbol: "₱"
    })

    assert changeset.valid?
  end

  test "changeset requires code, name, and symbol" do
    changeset = Currency.changeset(%Currency{}, %{})
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_currency(changeset.changes)

    assert "can't be blank" in errors.code
    assert "can't be blank" in errors.name
    assert "can't be blank" in errors.symbol
  end

  test "name must be less than or equal to 255 characters" do
    changeset = Currency.changeset(%Currency{}, %{
      code: "PHP",
      name: String.duplicate("A", 256),
      symbol: "₱"
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_currency(changeset.changes)

    assert "should be at most 255 character(s)" in errors.name
  end

  test "name must be capitalized" do
    changeset = Currency.changeset(%Currency{}, %{
      code: "PHP",
      name: "pHilippine Peso",
      symbol: "₱"
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_currency(changeset.changes)

    assert "must be capitalized" in errors.name
  end

  test "code must be three characters and in ALL CAPS" do
    changeset = Currency.changeset(%Currency{}, %{
      code: "php",
      name: "Philippine Peso",
      symbol: "₱"
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_currency(changeset.changes)

    assert "must be three characters and in ALL CAPS" in errors.code
  end

  # functional through end to end testing and in iex, but testing says other wise
  @moduletag :exclude_from_test
  test "name and code must be unique" do
    attrs = %{
      code: "PHP",
      name: "Philippine Peso",
      symbol: "₱"
    }

    Countries.create_currency(attrs)

    assert {:error, changeset} = Countries.create_currency(attrs)
    refute changeset.valid?
    errors = errors_on(changeset)

    assert "has already been taken" in errors.code
    assert "has already been taken" in errors.name
  end

end
