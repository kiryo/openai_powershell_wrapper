[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
#GUI (graafinen käyttöliittymä) 

#itse ikkuna
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(600,600)
$Form.Text = "GPT-3"


#textbox
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Size(10,50) 
$textbox.Multiline = $true
$textbox.Size = New-Object System.Drawing.Size(500,450) 
$textbox.Text = "This is GPT-3 API-Wrapper for powershell"
$textbox.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
$textbox.Name = "textbox"
$Form.Controls.Add($textbox)

#API-Key

#key
$key = New-Object System.Windows.Forms.TextBox
$key.Location = New-Object System.Drawing.Size(10,10) 
$key.Size = New-Object System.Drawing.Size(500,20) 
$key.Text = "Insert API-key here"
$key.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
$key.Name = "key"
$Form.Controls.Add($key)


#-------Napit-------

#Submit
$Submit = New-Object System.Windows.Forms.Button
$Submit.Location = New-Object System.Drawing.Size(350,520)
$Submit.Size = New-Object System.Drawing.Size(70,20)
$Submit.Text = "Submit"
$Submit.Name = "Submit"
#$Submit.Controls.Add($Submit) 
$Form.Controls.Add($Submit)

#Peruutus nappi
$Peruuta = New-Object System.Windows.Forms.Button
$Peruuta.Location = New-Object System.Drawing.Size(444,520)
$Peruuta.Size = New-Object System.Drawing.Size(70,20)
$Peruuta.Text = "Peruuta"
$Peruuta.Name = "Peruuta"
$Peruuta.Add_Click({$Form.Close()})
$Form.Controls.Add($Peruuta) 

# Buttons
#Enter key, i didn't manage to get ctrl + enter so i leave it here for someone to tinker


#$Form.KeyPreview = $True
#$Form.Add_KeyDown({
#if ($_.KeyCode -eq "Enter")
#    {

#            $Submit.PerformClick()
            [System.Windows.Forms.SendKeys]::SendWait("{BS}")
#    }
#})
        



#Submit button
$Submit.Add_Click({
$Form.Text = "Please wait..."
$query = $textbox.Text
$textbox.Text = $query
$uri     = 'https://api.openai.com/v1/engines/davinci/completions'
$headers = @{
    'Content-Type' = 'application/json'
    'Authorization'  = 'Bearer '+$key.Text
}
$data    = @{
    'prompt'   = $query
    'max_tokens' = 100
} |ConvertTo-Json

$output = invoke-RestMethod -Method Post -Headers $headers -Body $data -Uri $uri -ContentType 'application/json; charset=UTF-8' | select choices | ft -hide | Out-String
$clean = $output -replace '{@{text=',$query -replace '; index=0; logprobs=;','' -replace 'finish_reason=max_tokens}}','' -replace 'finish_reason=stop}}',''
$clean = $clean.Trimend() -replace "`t|`n|`r","" -replace " ;|; ",";" -replace "\.\.\.","" -replace '\s\s+',""

# typewriter effect
$Random = New-Object System.Random
$textbox.Text = $query
$clean = $clean -replace $query,''
$clean -split '' |
  ForEach-Object{
    $textbox.Text += $_ 
    Start-Sleep -milliseconds 100
   }
$Form.Text = "GPT-3" 
})


$Peruuta.Add_Click({
$host.exit()
    
})


[void] $Form.ShowDialog()

