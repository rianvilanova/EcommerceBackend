import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async (req)=>{
  try {
    const { order_id } = await req.json();

    if (!order_id) throw new Error("O 'order_id' é obrigatório no corpo da requisição.");

    const supabaseClient = createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_ANON_KEY'));

    const { data: items, error } = await supabaseClient.from('view_order_details') // Usando a nova view
      .select(`
          product_name,
          product_quantity,
          product_unit_price,
          order_total,
          customer_name,
          order_date
      `).eq('order_id', order_id);

    if (error) throw error;

    if (!items || items.length === 0) throw new Error("Pedido não encontrado ou não contém itens.");

    const headers = "Produto,Quantidade,Preco Unitario\n";
    const rows = items.map((item)=>`"${item.product_name}",${item.product_quantity},${item.product_unit_price}`).join("\n");
    const orderInfo = `Pedido ID: ${order_id}\nCliente: ${items[0].customer_name}\nData: ${new Date(items[0].order_date).toLocaleDateString('pt-BR')}\n\n`;
    const footer = `\n\nTotal do Pedido,,${items[0].order_total}`;
    const csvContent = orderInfo + headers + rows + footer;

    return new Response(csvContent, {
      headers: {
        'Content-Type': 'text/csv; charset=utf-8',
        'Content-Disposition': `attachment; filename="pedido-${order_id}.csv"`
      },
      status: 200
    });
    
  } catch (error) {
    return new Response(JSON.stringify({
      error: error.message
    }), {
      headers: {
        'Content-Type': 'application/json'
      },
      status: 400
    });
  }
});
