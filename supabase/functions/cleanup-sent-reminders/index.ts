import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// This function deletes all reminders that have already been sent.
Deno.serve(async (req) => {
  try {
    // Create an admin client to bypass RLS for this cleanup task.
    // It's crucial to use the SERVICE_ROLE_KEY for delete operations.
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Delete all rows from the 'reminders' table where 'is_sent' is true.
    const { error } = await supabaseAdmin
      .from('reminders')
      .delete()
      .eq('is_sent', true);

    if (error) {
      throw error;
    }

    console.info("Sucessfully executed cleanup function for reminders table");
    return new Response(JSON.stringify({ message: "Successfully cleaned up sent reminders." }), {
      headers: { 'Content-Type': 'application/json' },
      status: 200,
    });

  } catch (error) {
    console.error("Error in reminders cleanup function: " + error.message);
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});