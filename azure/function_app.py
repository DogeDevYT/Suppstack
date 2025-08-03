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

    if not supabase_url or not supabase_key:
        logging.error("Supabase URL or Service Key is not configured in Application Settings.")
        return

    # Set up the headers for the request to Supabase
    headers = {
        'Authorization': f'Bearer {supabase_key}',
        'Content-Type': 'application/json'
    }

    try:
        # Invoke the Supabase Edge Function by sending a POST request
        response = requests.post(url=supabase_url, headers=headers, json={})

        # Raise an exception for bad status codes (4xx or 5xx)
        response.raise_for_status()

        logging.info(f"Successfully invoked Supabase function. Status: {response.status_code}")

    except requests.exceptions.RequestException as e:
        logging.error(f"Failed to invoke Supabase function. Error: {e}")