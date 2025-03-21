FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

COPY NuGet.Config /root/.nuget/NuGet/NuGet.Config
COPY . .
WORKDIR "/app/GitHub.Actions.API"
RUN dotnet restore "GitHub.Actions.API.csproj"
RUN dotnet publish "GitHub.Actions.API.csproj" -o /app/build -c Release

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
ENV ASPNETCORE_ENVIRONMENT=Development
ENV TZ="Asia/Tashkent"
COPY --from=build-env /app/build .
ENTRYPOINT ["dotnet", "GitHub.Actions.API.dll", "--urls=http://0.0.0.0:4001"]