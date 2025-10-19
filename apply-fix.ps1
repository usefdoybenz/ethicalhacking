Write-Host "Aplicando fix de imagenes responsive..." -ForegroundColor Green

$directories = @("inyecciones_deloginsqlnosql", "pathtraversal", "subidadearchivomaliciosoweb-shell", "ataque-a-directorio-activo-as-reproast-attack", "enumeracion-ftp")

foreach ($dir in $directories) {
    $indexPath = Join-Path $dir "index.html"
    
    if (Test-Path $indexPath) {
        Write-Host "Procesando: $indexPath" -ForegroundColor Yellow
        
        $content = Get-Content $indexPath -Raw -Encoding UTF8
        
        if ($content -notmatch "responsive-images.css") {
            $search = '    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">'
            $replace = $search + "`r`n    `r`n    <!-- Responsive Images Fix -->`r`n    <link rel=`"stylesheet`" href=`"../assets/css/responsive-images.css`">"
            
            $newContent = $content.Replace($search, $replace)
            
            if ($newContent -ne $content) {
                $newContent | Out-File -FilePath $indexPath -Encoding UTF8 -NoNewline
                Write-Host "OK Fix aplicado a $indexPath" -ForegroundColor Green
            }
        } else {
            Write-Host "OK $indexPath ya tiene el fix" -ForegroundColor Cyan
        }
    } else {
        Write-Host "NO EXISTE $indexPath" -ForegroundColor Red
    }
}

Write-Host "Fix completado!" -ForegroundColor Green