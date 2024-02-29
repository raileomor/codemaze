#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app
EXPOSE 80
EXPOSE 443

# copy csproj and restore as distinct layers
COPY *.sln .
COPY CompanyEmployees/CompanyEmployees.csproj ./CompanyEmployees/
COPY CompanyEmployees.Presentation/CompanyEmployees.Presentation.csproj ./CompanyEmployees.Presentation/
COPY Contracts/Contracts.csproj ./Contracts/
COPY Entities/Entities.csproj ./Entities/
COPY LoggerService/LoggerService.csproj ./LoggerService/
COPY Repository/Repository.csproj ./Repository/
COPY Shared/Shared.csproj ./Shared/
WORKDIR /app/CompanyEmployees
RUN dotnet restore

# copy everything else and build app
WORKDIR /app/
COPY CompanyEmployees/. ./CompanyEmployees/
COPY CompanyEmployees.Presentation/. ./CompanyEmployees.Presentation/
COPY Contracts/. ./Contracts/
COPY Entities/. ./Entities/
COPY LoggerService/. ./LoggerService/
COPY Repository/. ./Repository/
COPY Shared/. ./Shared/
WORKDIR /app/CompanyEmployees
RUN dotnet publish -c release -o out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/CompanyEmployees/out ./
ENTRYPOINT ["dotnet", "CompanyEmployees.dll"]