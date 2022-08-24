defmodule Teacher.FilmTest do
  use Teacher.DataCase

  alias Teacher.Film

  describe "movies" do
    alias Teacher.Film.Movie

    @valid_attrs %{summary: "some summary", title: "some title", year: "some year"}
    @update_attrs %{
      summary: "some updated summary",
      title: "some updated title",
      year: "some updated year"
    }
    @invalid_attrs %{summary: nil, title: nil, year: nil}

    def movie_fixture(attrs \\ %{}) do
      {:ok, movie} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Film.create_movie()

      movie
    end

    test "list_movies/0 returns all movies" do
      movie = movie_fixture()
      assert Film.list_movies() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Film.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      assert {:ok, %Movie{} = movie} = Film.create_movie(@valid_attrs)
      assert movie.summary == "some summary"
      assert movie.title == "some title"
      assert movie.year == "some year"
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Film.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{} = movie} = Film.update_movie(movie, @update_attrs)
      assert movie.summary == "some updated summary"
      assert movie.title == "some updated title"
      assert movie.year == "some updated year"
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Film.update_movie(movie, @invalid_attrs)
      assert movie == Film.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Film.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Film.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Film.change_movie(movie)
    end
  end
end
