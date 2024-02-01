FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY . .
RUN dotnet restore "GitHub.Actions/GitHub.Actions.csproj"
WORKDIR "/app/GitHub.Actions"
RUN dotnet build "GitHub.Actions.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GitHub.Actions.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GitHub.Actions.dll", "--urls=http://0.0.0.0:4000"]