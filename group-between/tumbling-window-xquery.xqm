module namespace djb = "http://www.obdurodon.org";
declare function djb:process-insults($input as document-node()) as element(insult)+
{
  for tumbling window $word in $input//wordHoardTaggedLine/*
    start $s when $s instance of element(insultStart)
    end $e when $e instance of element(insultEnd)
  return
    <insult>{$word}</insult>
};
