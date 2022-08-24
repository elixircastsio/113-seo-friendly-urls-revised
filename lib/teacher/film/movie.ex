defmodule Teacher.Film.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :summary, :string
    field :title, :string
    field :year, :string

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :summary, :year])
    |> unique_constraint(:title)
    |> validate_required([:title, :summary, :year])
  end
end
