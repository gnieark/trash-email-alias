require ["vnd.dovecot.execute","variables","fileinto", "envelope", "subaddress","vacation","vacation-seconds"];
if envelope :detail "to" "spam"{
  fileinto "Spam";
}
if header :contains ["to", "cc"]
 [
  "alias@tinad.fr"
 ]{
  if address :matches "from" "*" { set "from" "${1}"; }
  if execute :output "response" "genalias.sh" [ "${from}" ]{
    vacation :seconds 1801 "${response}";
  }
}
 
