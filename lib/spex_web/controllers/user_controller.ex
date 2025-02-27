defmodule SpexWeb.UserController do
  use SpexWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias SpexWeb.Schemas.{UserRequest, UserResponse}
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  tags ["users"]

  operation :update,
    summary: "Update user",
    parameters: [
      id: [in: :path, description: "User ID", type: :integer, example: 1001]
    ],
    request_body: {"User params", "application/json", UserRequest},
    responses: %{
      :ok => {"User response", "application/json", UserResponse},
      422 => OpenApiSpex.JsonErrorResponse.response()
    }

  def update(conn, %{id: id}) do
    json(conn, %{
      data: %{
        id: id,
        name: "joe user",
        email: "joe@gmail.com"
      }
    })
  end
end
