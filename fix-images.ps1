# Simple script to add responsive CSS to HTML files
Write-Host "Aplicando fix de imágenes responsive..." -ForegroundColor Green

# Lista de directorios a procesar
$directories = @(
    "inyecciones_deloginsqlnosql",
    "pathtraversal", 
    "subidadearchivomaliciosoweb-shell",
    "ataque-a-directorio-activo-as-reproast-attack",
    "enumeracion-ftp"
)

foreach ($dir in $directories) {
    $indexPath = Join-Path $dir "index.html"
    
    if (Test-Path $indexPath) {
        Write-Host "Procesando: $indexPath" -ForegroundColor Yellow
        
        # Leer contenido
        $content = Get-Content $indexPath -Raw -Encoding UTF8
        
        # Verificar si ya tiene el CSS
        if ($content -notcontains "responsive-images.css") {
            # Buscar Font Awesome link y agregar nuestro CSS después
            $search = '    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">'
            $replace = $search + "`r`n    `r`n    <!-- Responsive Images Fix -->`r`n    <link rel=`"stylesheet`" href=`"../assets/css/responsive-images.css`">"
            
            $newContent = $content.Replace($search, $replace)
            
            # Guardar archivo
            if ($newContent -ne $content) {
                $newContent | Out-File -FilePath $indexPath -Encoding UTF8 -NoNewline
                Write-Host "✓ Fix aplicado a $indexPath" -ForegroundColor Green
            }
        } else {
            Write-Host "✓ $indexPath ya tiene el fix" -ForegroundColor Cyan
        }
    } else {
        Write-Host "× $indexPath no existe" -ForegroundColor Red
    }
}

Write-Host "`n¡Fix completado!" -ForegroundColor Green