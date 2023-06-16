<?php

class Settings_Model extends Model
{
    public function __construct()
    {
        // Call the Model constructor
        parent::__construct();
        if (isset($_COOKIE["xpkey"])) {
            $key_login = explode(':', $_COOKIE["xpkey"]);
            $Ukey = $key_login[0];
            $Pkey = $key_login[1];
            $query = $this->db->prepare("select * from setting where adminuser='" . $Ukey . "' and login_key='" . $_COOKIE["xpkey"] . "'");
            $query->execute();
            $queryCount = $query->rowCount();
            $query_ress = $this->db->prepare("select * from admins where username_u='" . $Ukey . "' and login_key='" . $_COOKIE["xpkey"] . "'");
            $query_ress->execute();
            $queryCount_ress = $query_ress->rowCount();
            if ($queryCount == 0 && $queryCount_ress == 0) {
                header("location: login");
            }
        } else {
            header("location: login");
        }
    }

    public function Get_settings()
    {
        $query = $this->db->prepare("select * from setting");
        $query->execute();
        $queryCount = $query->fetchAll();
        return $queryCount;
    }

    public function submit_pass($data_sybmit)
    {
        $sql = "UPDATE setting SET adminpassword=? WHERE id=?";
        $this->db->prepare($sql)->execute([$data_sybmit['password'], '1']);
        file_put_contents("/var/www/html/cp/Config/database.php", str_replace("\$password = \"" . $data_sybmit['password_old'] . "\"", "\$password = \"" . $data_sybmit['password'] . "\"", file_get_contents("/var/www/html/cp/Config/database.php")));
        shell_exec("htpasswd -b -c /etc/apache2/.htpasswd " . $data_sybmit['username_r'] . " " . $data_sybmit['password']);
        $restpass = $this->db->prepare("SET PASSWORD FOR '" . $data_sybmit['username_r'] . "'@'localhost' = PASSWORD('" . $data_sybmit['password'] . "');");
        $restpass->execute();
        $fixpass = $this->db->prepare("GRANT ALL ON *.* TO '" . $data_sybmit['username_r'] . "'@'localhost'");
        $fixpass->execute();
        header("Location: Settings&sort=chengepass&pos=success");
    }

    public function submit_port($data_sybmit)
    {
        $sshport = $data_sybmit['sshport'];
        $sql = "UPDATE setting SET sshport=? WHERE id=?";
        $this->db->prepare($sql)->execute([$sshport, '1']);
        //shell_exec("sudo sed -i \"s/".$data_sybmit['sshport_old']."/".$data_sybmit['sshport']."/g\" /var/www/html/cp/Config/database.php &");
        shell_exec("sudo sed -i 's/port = \"" . $data_sybmit['sshport_old'] . "\"/port = \"" . $data_sybmit['sshport'] . "\"/' /var/www/html/cp/Config/database.php");
        shell_exec("sudo sed -i 's/Port " . $data_sybmit['sshport_old'] . "/Port " . $data_sybmit['sshport'] . "/' /etc/ssh/sshd_config");
        $com = $data_sybmit['sshtlsport'] . ' ' . $data_sybmit['sshport'];
        shell_exec("bash Libs/sh/stunnel.sh $com");
        $sql = "UPDATE setting SET ssh_tls_port=? WHERE id=?";
        $this->db->prepare($sql)->execute($data_sybmit['sshtlsport'], '1']);
        shell_exec("sudo systemctl enable stunnel4");
        shell_exec("sudo systemctl restart stunnel4");
        shell_exec("sudo reboot");
        header("Location: Settings&sort=port");
    }

    public function submit_bot($data_sybmit)
    {
        $tokenbot = $data_sybmit['tokenbot'];
        $idtelegram = $data_sybmit['idtelegram'];
        $sql = "UPDATE setting SET tgtoken=?,tgid=? WHERE id=?";
        $this->db->prepare($sql)->execute([$tokenbot, $idtelegram, '1']);
        header("Location: Settings&sort=telegram");
    }

    public function index_api()
    {
        $query = $this->db->prepare("select * from ApiToken");
        $query->execute();
        $queryCount = $query->fetchAll(PDO::FETCH_ASSOC);
        return $queryCount;
    }

    public function submit_api($data_sybmit)
    {
        $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $token = substr(str_shuffle($chars), 0, 15);
        $sql1 = "INSERT INTO `ApiToken` (`Token`, `Description`, `Allowips`, `enable` ) VALUES (?,?,?,?)";
        $stmt1 = $this->db->prepare($sql1);
        $stmt1->execute(array(time() . $token, $data_sybmit['desc'], $data_sybmit['allowip'], 'true'));
        header("Location: Settings&sort=api");
    }

    public function renew_api($data)
    {
        $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $token = substr(str_shuffle($chars), 0, 15);
        $sql = "UPDATE ApiToken SET Token=? WHERE Token=?";
        $this->db->prepare($sql)->execute([time() . $token, $data]);
        header("Location: Settings&sort=api");
    }

    public function delete_api($data)
    {
        $this->db->prepare("DELETE FROM ApiToken WHERE Token=?")->execute([$data]);
        header("Location: Settings&sort=api");
    }

    public function submit_multiuser_on_limit($data_sybmit)
    {
        $sql = "UPDATE setting SET multiuser=? WHERE id=?";
        $this->db->prepare($sql)->execute(['on', '1']);
        header("Location: Settings&sort=user");
    }

    public function submit_multiuser_off_limit($data_sybmit)
    {
        $sql = "UPDATE setting SET multiuser=? WHERE id=?";
        $this->db->prepare($sql)->execute(['off', '1']);
        header("Location: Settings&sort=user");
    }

    public function submit_status_multiuser_on($data_sybmit)
    {
        $sql = "UPDATE setting SET ststus_multiuser=? WHERE id=?";
        $this->db->prepare($sql)->execute(['on', '1']);
        header("Location: Settings&sort=user");
    }

    public function submit_status_multiuser_off($data_sybmit)
    {
        $sql = "UPDATE setting SET ststus_multiuser=? WHERE id=?";
        $this->db->prepare($sql)->execute(['off', '1']);
        header("Location: Settings&sort=user");
    }

    public function submit_restor_backup($data_sybmit)
    {
        echo $data_sybmit['name'];
        if (strpos($data_sybmit['name'], ".sql") !== false) {
            shell_exec("mysql -u '" . DB_USER . "' --password='" . DB_PASS . "' XPanel < /var/www/html/cp/storage/backup/" . $data_sybmit['name']);
            $stmt = $this->db->prepare("SELECT * FROM users where enable='true'");
            $stmt->execute();
            $data = $stmt->fetchAll();
            foreach ($data as $row) {
                shell_exec("bash Libs/sh/adduser " . $row["username"] . " " . $row["password"]);
            }
            echo '
            <div class="p-4 mb-2" style="position: fixed;z-index: 9999;left: 0;">
              <div class="toast fade show" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                  <img src="' . path . 'assets/images/xlogo.png" class="img-fluid m-r-5" alt="XPanel" style="width: 17px">
                  <strong class="me-auto">XPanel</strong>
                  <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">' . confirm_success_lang . '</div>
              </div>
            </div>';
        }
    }

    public function submit_fakeurl($data_sybmit)
    {
        file_put_contents("/var/www/html/cp/Config/define.php", str_replace("\$fakeurl = \"" . $data_sybmit['fake_address_old'] . "\"", "\$fakeurl = \"" . $data_sybmit['fake_address'] . "\"", file_get_contents("/var/www/html/cp/Config/define.php")));
        $txt = '
        <?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
function curl_get_contents($url) {
    $ch = curl_init();
    $header[0] = "Accept: text/xml,application/xml,application/xhtml+xml,font/woff,font/woff2,";
    $header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5,application/font-woff,*";
    $header[] = "Access-Control-Allow-Origin: *";
    $header[] = "Connection: keep-alive";
    $header[] = "Keep-Alive: 300";
    $header[] = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
    $header[] = "Accept-Language: en-us,en;q=0.5";
    curl_setopt( $ch, CURLOPT_HTTPHEADER, $header );

    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_URL, $url);

    // I have added below two lines
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

    $data = curl_exec($ch);
    curl_close($ch);

    return $data;
}
$site = "' . $data_sybmit['fake_address'] . '";
echo curl_get_contents("$site");
        ';
        file_put_contents("/var/www/html/example/index.php", $txt);
        header("Location: Settings&sort=fakeaddress");
    }

    public function submit_blockip($data_sybmit)
    {
        $list_block = $data_sybmit['list_block'];
        $fp = fopen('/var/www/html/cp/Libs/iplist.txt', 'w');
        fwrite($fp, $list_block);
        fclose($fp);
        header("Location: Settings&sort=block");
    }
}
