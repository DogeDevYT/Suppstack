import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// This function will be called by the Supabase Cron Job.
Deno.serve(async (req) => {
  try {
    // Create an admin client to bypass RLS
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Find all reminders that are due and have not been sent
    const { data: reminders, error } = await supabaseAdmin
      .from('reminders')
      .select('*')
      .lte('remind_at', new Date().toISOString())
      .eq('is_sent', false);

    if (error) throw error;

    // For each due reminder, invoke the send-reminder function
    for (const reminder of reminders) {
      await supabaseAdmin.functions.invoke('send-reminder', {
        body: {
          user_id: reminder.user_id,
          supplement_name: reminder.supplement_name,
        },
      });

      // Mark the reminder as sent to prevent duplicates
      await supabaseAdmin
        .from('reminders')
        .update({ is_sent: true })
        .eq('id', reminder.id);
    }

    return new Response(JSON.stringify({ message: `Processed ${reminders.length} reminders.` }), {
      headers: { 'Content-Type': 'application/json' },
      status: 200,
    });

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});