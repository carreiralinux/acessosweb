<?php
$clientaddr   = (isset($_GET['clientaddr']))  ? $_GET['clientaddr']  : null;
$clientuser   = (isset($_GET['clientuser']))  ? $_GET['clientuser']  : null;
$clientname   = (isset($_GET['clientname']))  ? $_GET['clientname']  : null;
$clientgroup  = (isset($_GET['clientgroup'])) ? $_GET['clientgroup'] : null;
$targetgroup  = (isset($_GET['targetgroup'])) ? $_GET['targetgroup'] : null;
$srcclass     = (isset($_GET['srcclass']))    ? $_GET['srcclass']    : null;
$targetclass  = (isset($_GET['targetclass'])) ? $_GET['targetclass'] : null;
$url          = (isset($_GET['url']))         ? $_GET['url']         : null;
$local	= (isset($_GET['local']))       ? $_GET['local']       : null;   
?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">        
        <title>Acesso negado</title>
        <style>
            .bd-placeholder-img {
                font-size: 1.125rem;
                text-anchor: middle;
                -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                user-select: none;
            }

            @media (min-width: 768px) {
                .bd-placeholder-img-lg {
                    font-size: 3.5rem;
                }
            }
        </style>
        <link href="https://getbootstrap.com/docs/4.3/examples/cover/cover.css" rel="stylesheet">
    </head>
    <body>        
        <div class="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
            <header class="masthead mb-auto">
                <div class="inner">
                    <h3 class="masthead-brand"></h3>      
                </div>
            </header>
            <main role="main" class="inner cover">
                <h1 class="cover-heading">Acesso proibido.</h1>
                <p class="lead">O conte&uacute;do que voc&ecirc; deseja acessar não est&aacute; liberado.<br>
                    Para acessar esse conte&uacute;do entre em contato com o administrador da rede.
                </p> 
                <table>
                    <tbody>
                        <tr>
                            <td align="left"><b>Cliente:</b></td>
                            <td><?php echo $clientaddr; ?></td>
                        </tr>
                        <tr>
                            <td align="left"><b>Usu&aacute;rio:</b></td>
                            <td><?php echo $clientuser; ?></td>
                        </tr>
                        <tr>
                            <td align="left"><b>Grupo:</b></td>
                            <td><?php echo $clientgroup; ?></td>
                        </tr>
                        <tr>
                            <td align="left"><b>P&aacute;gina:</b></td>
                            <td><?php echo $url; ?></td>
                        </tr>
                    </tbody>
                </table>
            </main>
            <footer class="mastfoot mt-auto">
            </footer>
        </div>
    </body>
</html>

