FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY DockerCore/*.csproj ./DockerCore/
RUN dotnet restore

# copy everything else and build app
COPY DockerCore/. ./DockerCore/
WORKDIR /app/DockerCore
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/DockerCore/out ./
ENTRYPOINT ["dotnet", "DockerCore.dll"]
