-- Para a tabela "profiles"
ALTER POLICY "Clientes só podem atualizar o próprio perfil."
ON public.profiles USING (auth.uid() = id);

ALTER POLICY "Clientes só podem ver o seu próprio perfil."
ON public.profiles USING (auth.uid() = id);


-- Para a tabela "orders"
ALTER POLICY "Clientes só podem ver seus próprios pedidos."
ON public.orders USING (auth.uid() = customer_id);

ALTER POLICY "Clientes só podem criar pedidos para eles mesmos."
ON public.orders WITH CHECK (auth.uid() = customer_id);


-- Para a tabela "order_items"
ALTER POLICY "Clientes só podem ver os itens dos seus próprios pedidos."
ON public.order_items USING (
  (SELECT customer_id FROM public.orders WHERE id = order_items.order_id) = auth.uid()
);