defmodule TeacherWeb.MovieLiveTest do
  use TeacherWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Teacher.Film

  @create_attrs %{summary: "some summary", title: "some title", year: "some year"}
  @update_attrs %{
    summary: "some updated summary",
    title: "some updated title",
    year: "some updated year"
  }
  @invalid_attrs %{summary: nil, title: nil, year: nil}

  defp fixture(:movie) do
    {:ok, movie} = Film.create_movie(@create_attrs)
    movie
  end

  defp create_movie(_) do
    movie = fixture(:movie)
    %{movie: movie}
  end

  describe "Index" do
    setup [:create_movie]

    test "lists all movies", %{conn: conn, movie: movie} do
      {:ok, _index_live, html} = live(conn, Routes.movie_index_path(conn, :index))

      assert html =~ "Listing Movies"
      assert html =~ movie.summary
    end

    test "saves new movie", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.movie_index_path(conn, :index))

      assert index_live |> element("a", "New Movie") |> render_click() =~
               "New Movie"

      assert_patch(index_live, Routes.movie_index_path(conn, :new))

      assert index_live
             |> form("#movie-form", movie: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#movie-form", movie: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.movie_index_path(conn, :index))

      assert html =~ "Movie created successfully"
      assert html =~ "some summary"
    end

    test "updates movie in listing", %{conn: conn, movie: movie} do
      {:ok, index_live, _html} = live(conn, Routes.movie_index_path(conn, :index))

      assert index_live |> element("#movie-#{movie.id} a", "Edit") |> render_click() =~
               "Edit Movie"

      assert_patch(index_live, Routes.movie_index_path(conn, :edit, movie))

      assert index_live
             |> form("#movie-form", movie: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#movie-form", movie: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.movie_index_path(conn, :index))

      assert html =~ "Movie updated successfully"
      assert html =~ "some updated summary"
    end

    test "deletes movie in listing", %{conn: conn, movie: movie} do
      {:ok, index_live, _html} = live(conn, Routes.movie_index_path(conn, :index))

      assert index_live |> element("#movie-#{movie.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#movie-#{movie.id}")
    end
  end

  describe "Show" do
    setup [:create_movie]

    test "displays movie", %{conn: conn, movie: movie} do
      {:ok, _show_live, html} = live(conn, Routes.movie_show_path(conn, :show, movie))

      assert html =~ "Show Movie"
      assert html =~ movie.summary
    end

    test "updates movie within modal", %{conn: conn, movie: movie} do
      {:ok, show_live, _html} = live(conn, Routes.movie_show_path(conn, :show, movie))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Movie"

      assert_patch(show_live, Routes.movie_show_path(conn, :edit, movie))

      assert show_live
             |> form("#movie-form", movie: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#movie-form", movie: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.movie_show_path(conn, :show, movie))

      assert html =~ "Movie updated successfully"
      assert html =~ "some updated summary"
    end
  end
end
