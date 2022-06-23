output "postgres_db_name" {
  value       = azurerm_postgresql_flexible_server.postgres_server.name
  description = "output the name of the postgres server"
}