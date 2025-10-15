import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
const resendKey = Deno.env.get('RESEND_API_KEY');
const fromEmail = Deno.env.get('FROM_EMAIL');

const supabase = createClient(supabaseUrl, supabaseKey);

Deno.serve(async (req)=>{
  try {
    const { order_id } = await req.json();
    if (!order_id) {
      return new Response(JSON.stringify({
        error: "order_id é obrigatório"
      }), {
        status: 400
      });
    }

    const { data: orderData, error: orderErr } = await supabase.from('orders').select('id, customer_id, total, status').eq('id', order_id).single();
    if (orderErr || !orderData) {
      return new Response(JSON.stringify({
        error: "Pedido não encontrado"
      }), {
        status: 404
      });
    }

    const { data: userData, error: userErr } = await supabase.auth.admin.getUserById(orderData.customer_id);
    if (userErr || !userData?.user.email) {
      return new Response(JSON.stringify({
        error: "Email do cliente não encontrado"
      }), {
        status: 404
      });
    }

    const subject = `Confirmação do Pedido ${order_id}`;
    const html = `<h1>Obrigado pelo seu pedido!</h1>
                  <p>Pedido ID: ${order_id}</p>
                  <p>Total: R$ ${orderData.total}</p>
                  <p>Status: ${orderData.status}</p>`;

    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${resendKey}`
      },
      body: JSON.stringify({
        from: 'Rian Vilanova <onboarding@resend.dev>',
        to: "rianvlnv@gmail.com",
        subject,
        html
      })
    });

    const respData = await res.json();

    return new Response(JSON.stringify({
      success: true,
      resend: respData
    }), {
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({
      error: err.message
    }), {
      status: 500
    });
  }
});
