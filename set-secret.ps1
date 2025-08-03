# This script reads the content of your Google service account key
# and securely sets it as a secret in your Supabase project in a more robust way.

try {
    # Read the entire content of the JSON file into a single string
    $jsonContent = Get-Content -Raw -Path "./google-service-account.json"

    # Construct the final command string
    $secretPair = "GOOGLE_SERVICE_ACCOUNT_JSON=$jsonContent"

    # --- KEY CHANGE ---
    # Use the pipe operator (|) to send the secret string directly to the
    # standard input of the Supabase CLI. This is the correct PowerShell syntax.
    Write-Host "Setting GOOGLE_SERVICE_ACCOUNT_JSON secret in Supabase..."
    echo $secretPair | npx supabase secrets set
    
    Write-Host "Secret set successfully!"
    Write-Host "Please redeploy your function now: supabase functions deploy send-reminder"

} catch {
    Write-Error "An error occurred: $_"
    Write-Error "Please make sure your 'google-service-account.json' file is in the same directory as this script."
}
