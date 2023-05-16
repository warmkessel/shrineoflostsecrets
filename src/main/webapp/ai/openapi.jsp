openapi: 3.1.0
info:
  title: Shrine of Lost Secrets
  description: Help the user generate dynamic content for Roll Playing Games.
  version: 'v1'
servers:
  - url: https://www.shrineoflostsecrets.com/
paths:
  /roll.jsp:
    get:
      operationId: generate a roll of the dice
      summary: Generate a roll of the requsteed dice
      responses:
        "200":
          description: OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/getTodosResponse'
components:
  schemas:
    getTodosResponse:
      type: object
      properties:
        todos:
          type: array
          items:
            type: string
          description: The list of todos.