defmodule SpexWeb.Schemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule ValidateName do
    alias OpenApiSpex.Cast

    def cast(ctx = %Cast{value: value, schema: schema}) do
      if value |> String.starts_with?("Joe") do
        %Cast{ctx | schema: %{schema | "x-validate": nil}} |> Cast.cast()
        # Cast.ok(ctx)
      else
        Cast.error(ctx, {:custom, "Invalid name, no joe"})
      end
    end
  end

  defmodule User do
    OpenApiSpex.schema(%Schema{
      # The title is optional. It defaults to the last section of the module name.
      # So the derived title for MyApp.User is "User".
      title: "User",
      description: "A user of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "User ID"},
        name: %Schema{
          type: :string,
          description: "User name",
          pattern: ~r/^[a-zA-Z][a-zA-Z0-9_]+$/,
          maxLength: 3,
          "x-validate": ValidateName
        },
        email: %Schema{type: :string, description: "Email address", format: :email},
        birthday: %Schema{type: :string, description: "Birth date", format: :date},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:name, :email],
      example: %{
        "id" => 123,
        "name" => "Joe User",
        "email" => "joe@gmail.com",
        "birthday" => "1970-01-01T12:34:55Z",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule UserRequest do
    OpenApiSpex.schema(%{
      title: "UserRequest",
      description: "POST body for creating a user",
      type: :object,
      properties: %{
        user: %Schema{anyOf: [User]}
      },
      required: [:user],
      example: %{
        "user" => %{
          "name" => "Joe User",
          "email" => "joe@gmail.com"
        }
      }
    })
  end

  defmodule UserResponse do
    OpenApiSpex.schema(%{
      title: "UserResponse",
      description: "Response schema for single user",
      type: :object,
      properties: %{
        data: User
      },
      example: %{
        "data" => %{
          "id" => 123,
          "name" => "Joe User",
          "email" => "joe@gmail.com",
          "birthday" => "1970-01-01T12:34:55Z",
          "inserted_at" => "2017-09-12T12:34:55Z",
          "updated_at" => "2017-09-13T10:11:12Z"
        }
      }
    })
  end
end
