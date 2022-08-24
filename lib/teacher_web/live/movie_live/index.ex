defmodule TeacherWeb.MovieLive.Index do
  use TeacherWeb, :live_view

  alias Teacher.Film
  alias Teacher.Film.Movie

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :movies, list_movies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Movie")
    |> assign(:movie, Film.get_movie!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Movie")
    |> assign(:movie, %Movie{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Movies")
    |> assign(:movie, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    movie = Film.get_movie!(id)
    {:ok, _} = Film.delete_movie(movie)

    {:noreply, assign(socket, :movies, list_movies())}
  end

  defp list_movies do
    Film.list_movies()
  end
end
