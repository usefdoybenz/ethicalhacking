# Script para aplicar el CSS responsive a todas las páginas del blog
# PowerShell script to add responsive images CSS to all HTML files

Write-Host "Aplicando fix de imágenes responsive al blog HackingUsef..." -ForegroundColor Green

# Buscar todos los archivos index.html en subdirectorios
$htmlFiles = Get-ChildItem -Path "." -Recurse -Name "index.html" | Where-Object { $_ -notmatch "wp-" }

foreach ($file in $htmlFiles) {
    $fullPath = Join-Path (Get-Location) $file
    $content = Get-Content $fullPath -Raw -Encoding UTF8
    
    # Verificar si ya tiene el link al CSS responsive
    if ($content -notmatch "responsive-images.css") {
        Write-Host "Aplicando fix a: $file" -ForegroundColor Yellow
        
        # Buscar la línea de Font Awesome y agregar nuestro CSS después
        $fontAwesomePattern = '(\s*<link rel="stylesheet" href="https://cdnjs\.cloudflare\.com/ajax/libs/font-awesome/[^"]+">)\s*\n(\s*\n)?(\s*<style>)'
        $replacement = '$1' + "`r`n    `r`n    <!-- Responsive Images Fix -->`r`n    <link rel=`"stylesheet`" href=`"../assets/css/responsive-images.css`">`r`n`$2`$3"
        
        $newContent = $content -replace $fontAwesomePattern, $replacement
        
        # Si hubo cambios, guardar el archivo
        if ($newContent -ne $content) {
            $newContent | Out-File -FilePath $fullPath -Encoding UTF8 -NoNewline
            Write-Host "✓ Fix aplicado correctamente a $file" -ForegroundColor Green
        } else {
            Write-Host "! No se pudo aplicar automáticamente a $file - revisar manualmente" -ForegroundColor Red
        }
    } else {
        Write-Host "✓ $file ya tiene el fix aplicado" -ForegroundColor Cyan
    }
}

Write-Host "`n¡Fix de imágenes responsive aplicado!" -ForegroundColor Green
Write-Host "Las imágenes ahora deberían ajustarse correctamente en todos los dispositivos." -ForegroundColor White

# Mostrar estadísticas
$processedFiles = ($htmlFiles | Measure-Object).Count
Write-Host "`nArchivos procesados: $processedFiles" -ForegroundColor Magenta