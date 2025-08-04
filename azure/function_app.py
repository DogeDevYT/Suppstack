import azure.functions as func
import logging
import os
import requests

app = func.FunctionApp()

@app.timer_trigger(schedule="0 */5 * * * *", arg_name="myTimer", run_on_startup=False,
              use_monitor=False) 
def InvokeSupabase(myTimer: func.TimerRequest) -> None:
    
    if myTimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function executed.')

    # Get Supabase details from Application Settings (environment variables)
    supabase_url = os.environ.get('SUPABASE_FUNCTION_URL')
    supabase_key = os.environ.get('SUPABASE_SERVICE_KEY')

    #get secondary reminder cleanup function url to clean up reminders table
    supabase_reminders_cleanup_url = os.environ.get("SUPABASE_CLEANUP_URL")

    if not (supabase_url and supabase_key and supabase_reminders_cleanup_url):
        logging.error("Supabase URL, Service Key, or cleanup reminders URL is not configured in Application Settings.")
        return

    # Set up the headers for the request to Supabase
    headers = {
        'Authorization': f'Bearer {supabase_key}',
        'Content-Type': 'application/json'
    }

    #check_reminders
    try:
        # Invoke the Supabase Edge Function by sending a POST request
        response = requests.post(url=supabase_url, headers=headers, json={})

        # Raise an exception for bad status codes (4xx or 5xx)
        response.raise_for_status()

        logging.info(f"Successfully invoked Supabase check-reminders function. Status: {response.status_code}")

    except requests.exceptions.RequestException as e:
        logging.error(f"Failed to invoke Supabase check-reminders function. Error: {e}")
    
    #cleanup reminders
    try:
        # Invoke the Supabase Edge Function by sending a POST request
        response = requests.post(url=supabase_url, headers=headers, json={})

        # Raise an exception for bad status codes (4xx or 5xx)
        response.raise_for_status()

        logging.info(f"Successfully invoked Supabase cleanup-sent-reminders function. Status: {response.status_code}")

    except requests.exceptions.RequestException as e:
        logging.error(f"Failed to invoke Supabase cleanup-sent-reminders function. Error: {e}")