return {
  {
    "turbio/bracey.vim",
    ft = { "html", "javascript", "css" }, -- carga solo en archivos relevantes
    build = "npm install --prefix server", -- instala dependencias automáticamente
    cmd = { "Bracey", "BraceyStop", "BraceyReload" }, -- activa comandos de forma lazy
  }
}
