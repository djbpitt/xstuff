module namespace djb = "http://www.obdurodon.org";
declare function djb:gis($input as document-node()) as element(gi)+ {
  let $gis as xs:string+ := $input/descendant::* ! name() => distinct-values()
  for $gi in distinct-values($gis)
  order by lower-case($gi)
  return
    <gi>{$gi}</gi>
};
declare function djb:greet() as xs:string {
  'hi'
};
