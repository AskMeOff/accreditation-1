<style>
    .rolledUp {
        width: 25px;
        transition: 2s linear;
    }

    .rightCardFS {
        width: 100%;
        transition: 2s linear;
    }

    .rightCard65 {
        width: 100%;
        transition: 2s linear;
    }

    .hiddentab {
        display: none;
    }

    .margleft {
        padding-left: 20px;
    }

    .tooltip1 {
        position: fixed;
        padding: 10px 20px;
        border: 1px solid #b3c9ce;
        border-radius: 4px;
        text-align: center;
        font: italic 14px/1.3 sans-serif;
        color: #333;
        background: #fff;
        box-shadow: 3px 3px 3px rgba(0, 0, 0, .3);
        z-index: 9999;
    }

    #formDateDorabotka {
        margin-left: 2px;
    }

    #formFileReportDorabotka {
        margin-left: 2px;
    }


</style>

<style>

    .container {
        padding: 0rem 0rem;
    }

    .leftSide {
        margin-left: 0;
        margin-right: 0;
    }

    h4 {
        margin: 2rem 0rem 1rem;
    }

    .table-image {

    td, th {
        vertical-align: middle;
    }

    }

</style>
<?php if (isset($_COOKIE['login'])) { ?>

    <?php
    $login = $_COOKIE['login'];
    $insertquery = "SELECT u.id_role, u.id_user, uz.oblast
                    FROM users u
                    left outer join uz on u.id_uz=uz.id_uz 
                    WHERE login='$login'";

    $rez = mysqli_query($con, $insertquery) or die("Ошибка " . mysqli_error($con));
    $username = "";
    if (mysqli_num_rows($rez) == 1) //если нашлась одна строка, значит такой юзер существует в базе данных
    {
        $row = mysqli_fetch_assoc($rez);
        $id = $row['id_user'];
        $id_role = $row['id_role'];
        $oblast = $row['oblast'];
    }

    ?>


    <div class="content-wrapper">
        <div class="row" id="proBanner">
            <div class="col-12">
                <!--    -->
            </div>
        </div>
        <div class="d-xl-flex justify-content-between align-items-start">
            <h2 class="text-dark font-weight-bold mb-2"> Заявления </h2>
            <div class="d-sm-flex justify-content-xl-between align-items-center mb-2">

            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="d-sm-flex justify-content-between align-items-center transaparent-tab-border ">
                    <ul class="nav nav-tabs tab-transparent" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="home-tab" data-toggle="tab" href="#allApps" role="tab"
                               aria-selected="true">Самоаккредитация</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link " id="rassmotrenie-tab" data-toggle="tab" href="#rassmotrenie" role="tab"
                               aria-selected="false">Отправленные</a>
                        </li>
                        <?php include "ajax/includeRole.php";
//                        if ($role == "14"){
//                        ?>

                        <li class="nav-item">
                            <a class="nav-link " id="rkk-tab" data-toggle="tab" href="#rkk" role="tab"
                               aria-selected="false">На рассмотрении</a>
                        </li>
                            <li class="nav-item">
                                <a class="nav-link" id="odobrennie-tab" data-toggle="tab" href="#" role="tab"
                                   aria-selected="false">Завершена оценка</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="reshenieSoveta-tab" data-toggle="tab" href="#" role="tab"
                                   aria-selected="false">Решение</a>
                            </li>
                        <li class="nav-item">
                            <a class="nav-link" id="accredArchiveNew-tab" data-toggle="tab" href="#" role="tab"
                               aria-selected="false">Архив</a>
                        </li>
<!--                        --><?php //}?>
                    </ul>
                    <div class="d-md-block d-none">
                        <!--                    <a href="#" class="text-light p-1"><i class="mdi mdi-view-dashboard"></i></a>-->
                        <!--                    <a href="#" class="text-light p-1"><i class="mdi mdi-dots-vertical"></i></a>-->
                    </div>
                </div>
                <div class="tab-content tab-transparent-content">
                    <div class="tab-pane fade show active" id="allApps" role="tabpanel" aria-labelledby="home-tab">

                        <div class="row">
                            <div class="col-12 grid-margin">
                                <div class="card">
                                    <div class="card-body">

                                        <?php


                                         if ($oblast == "0")
                                        {
                                            $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where  '$id_role'=12 and (id_status = 1)";

                                        }else {
                                             $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                        
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where  (('$id_role'=12 and (id_status = 1 or id_status = 5)) or ('$id_role'=14 and (uz.oblast='$oblast')) and (id_status = 1))";
                                         }
                                        $result = mysqli_query($con, $query) or die (mysqli_error($con));
                                        for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row) ;
                                        ?>

                                        <table id="example" class="table table-striped table-bordered"
                                               style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>Заявления</th>
                                                <th>Дата создания заявления</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <?php

                                            foreach ($data as $app) {
                                                $username = $app['username'];
                                                include "ajax/mainMark.php";
                                                $id_application = $app['app_id'];
                                                ?>


                                                <tr onclick="newShowModal('<?= $app['app_id'] ?>')"
                                                    style="cursor: pointer;">


                                                    <td>Заявление <?= $username ?> №<?= $app['app_id'] ?></td>
                                                    <td><?= $app['date_create_app'] ?></td>

                                                </tr>
                                                <?php
                                            }
                                            ?>

                                            </tbody>

                                        </table>


                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="tab-content tab-transparent-content">
                    <div class="tab-pane fade" id="rassmotrenie" role="tabpanel" aria-labelledby="rassmotrenie-tab">
                        <div class="row">
                            <div class="col-12 grid-margin">
                                <div class="card">
                                    <div class="card-body">

                                        <?php
//                                        $login = $_COOKIE['login'];
//                                        $insertquery = "SELECT * FROM users WHERE login='$login'";
//
//                                        $rez = mysqli_query($con, $insertquery) or die("Ошибка " . mysqli_error($con));
//                                        $username = "";
//                                        if (mysqli_num_rows($rez) == 1) //если нашлась одна строка, значит такой юзер существует в базе данных
//                                        {
//                                            $row = mysqli_fetch_assoc($rez);
//                                            $id = $row['id_user'];
//
//                                        }

                                        $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where  id_status in (2) and (('$id_role'=12) or ('$id_role'=14 and (uz.oblast='$oblast')))";
                                        $result = mysqli_query($con, $query) or die (mysqli_error($con));
                                        for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row) ;
                                        ?>

                                        <table id="examplet" class="table table-striped table-bordered"
                                               style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>Заявления</th>
                                                <th>Дата принятия на рассмотрение</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <?php

                                            foreach ($data as $app) {
                                                $username = $app['username'];
                                                include "ajax/mainMark.php";
                                                ?>

                                                <tr onclick="newShowModal('<?= $app['app_id'] ?>')"
                                                    style="cursor: pointer;">


                                                    <td>Заявление <?= $username ?> №<?= $app['app_id'] ?></td>
                                                    <td><?= $app['date_accept'] ?></td>


                                                </tr>
                                                <?php
                                            }
                                            ?>

                                            </tbody>

                                        </table>


                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>


                <div class="tab-content tab-transparent-content">
                    <div class="tab-pane fade" id="rkk" role="tabpanel" aria-labelledby="rkk-tab">
                        <div class="row">
                            <div class="col-12 grid-margin">
                                <div class="card">
                                    <div class="card-body">

                                        <?php


                                        $query = "SELECT * FROM users where login = '$login'";

                                        $rez = mysqli_query($con, $query) or die("Ошибка " . mysqli_error($con));
                                        if (mysqli_num_rows($rez) == 1) //если нашлась одна строка, значит такой юзер существует в базе данных
                                        {
                                            $row = mysqli_fetch_assoc($rez);
                                            $role = $row['id_role'];
                                        }
                                        if ($role > 3 && $role < 12) {
                                            $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id, r.date_reg
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                                left outer join rkk r on r.id_application=a.id_application
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where  (('$id_role'=12 and (id_status = 3)) or ('$id_role'=14 and (uz.oblast='$oblast')))";
                                        } else if ($role == 12) {

                                            $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id, r.date_reg
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join users us on us.id_user=a.id_user
                               left outer join rkk r on r.id_application=a.id_application
                        
                                left outer join uz uz on uz.id_uz =us.id_uz 
                                where  id_status = 3";
                                        }
                                        else {
                                            $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id, r.date_reg
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join users us on us.id_user=a.id_user
                               left outer join rkk r on r.id_application=a.id_application
                        
                                left outer join uz uz on uz.id_uz =us.id_uz 
                                where  uz.oblast='$oblast' and id_status = 3 and a.checkboxValueGuzo = 1";
                                        }
                                        $result = mysqli_query($con, $query) or die (mysqli_error($con));
                                        for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row) ;

                                        ?>

                                        <table id="example" class="table table-striped table-bordered"
                                               style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>Заявления</th>
                                                <th>Дата регистрации</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <?php

                                            foreach ($data as $app) {
                                                $username = $app['username'];
                                                include "ajax/mainMark.php";
                                                $id_application = $app['app_id'];
                                                ?>


                                                <tr onclick="newShowModall('<?= $app['app_id'] ?>')"
                                                    style="cursor: pointer;">


                                                    <td>Заявление <?= $username ?> №<?= $app['app_id'] ?></td>
                                                    <td><?= $app['date_reg'] ?></td>

                                                </tr>
                                                <?php
                                            }
                                            ?>

                                            </tbody>

                                        </table>


                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>


                <div class="tab-content tab-transparent-content">
                    <div class="tab-pane fade" id="odobrennie" role="tabpanel" aria-labelledby="odobrennie-tab">
                        <div class="row">
                            <div class="col-12 grid-margin">
                                <div class="card">
                                    <div class="card-body">

                                        <?php
                                        $query = "SELECT * FROM users where login = '$login'";

                                        $rez = mysqli_query($con, $query) or die("Ошибка " . mysqli_error($con));
                                        if (mysqli_num_rows($rez) == 1) //если нашлась одна строка, значит такой юзер существует в базе данных
                                        {
                                            $row = mysqli_fetch_assoc($rez);
                                            $role = $row['id_role'];
                                        }
                                        if ($role > 3 && $role < 12) {
                                            $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                        
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where  (('$id_role'=12 and (id_status = 4)) or ('$id_role'=14 and (uz.oblast='$oblast')))";
                                        } else if ($role == 12){

                                                $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                        
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where   id_status = 4";

                                        }
                                        else {

                                            $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                        
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where  uz.oblast='$oblast' and id_status = 4 and a.checkboxValueGuzo = 1";
                                        }
                                        $result = mysqli_query($con, $query) or die (mysqli_error($con));
                                        for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row) ;
                                        ?>

                                        <table id="example" class="table table-striped table-bordered"
                                               style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>Заявления</th>
                                                <th>Дата одобрения</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <?php

                                            foreach ($data as $app) {
                                                include "ajax/mainMark.php";
                                                ?>

                                                <tr onclick="newShowModal('<?= $app['app_id'] ?>')"
                                                    style="cursor: pointer;">


                                                    <td>Заявление <?= $app['username'] ?> №<?= $app['app_id'] ?></td>
                                                    <td><?= $app['date_complete'] ?></td>


                                                </tr>
                                                <?php
                                            }
                                            ?>

                                            </tbody>

                                        </table>


                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>


                <div class="tab-content tab-transparent-content">
                    <div class="tab-pane fade" id="reshenieSoveta" role="tabpanel" aria-labelledby="reshenieSoveta-tab">
                        <div class="row">
                            <div class="col-12 grid-margin">
                                <div class="card">
                                    <div class="card-body">

                                        <?php
                                        $query = "SELECT * FROM users where login = '$login'";

                                        $rez = mysqli_query($con, $query) or die("Ошибка " . mysqli_error($con));
                                        if (mysqli_num_rows($rez) == 1) //если нашлась одна строка, значит такой юзер существует в базе данных
                                        {
                                            $row = mysqli_fetch_assoc($rez);
                                            $role = $row['id_role'];
                                        }
                                        if ($role > 3 && $role < 12) {
                                            $query = "SELECT a.*, uz.username, uz.oblast, ram.*, a.id_application as app_id, r.date_protokol
                                                    FROM applications a
                                                   left outer join report_application_mark ram on a.id_application=ram.id_application
                                                    left outer join uz uz on uz.id_uz=a.id_user
                                                    left outer join rkk r on r.id_application=a.id_application
                                                   where id_status = 6 and u.oblast = '$role'";
                                        } else {
                                            $query = "SELECT a.*, uz.username, uz.oblast, ram.*, a.id_application as app_id, r.date_protokol
                                                    FROM applications a
                                                   left outer join report_application_mark ram on a.id_application=ram.id_application
                                                    left outer join uz uz on uz.id_uz=a.id_user
                                                    left outer join rkk r on r.id_application=a.id_application
                                                   where (('$id_role'=12 and (id_status = 6)) or ('$id_role'=14 and (id_status = 6) and  (uz.oblast='$oblast'))) 
							--	uz.oblast='$oblast' and id_status = 6
							";
                                        }
                                        $result = mysqli_query($con, $query) or die (mysqli_error($con));
                                        for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row) ;
                                        ?>

                                        <table id="example" class="table table-striped table-bordered"
                                               style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>Заявления</th>
                                                <th>Дата протокола</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <?php

                                            foreach ($data as $app) {
                                                include "ajax/mainMark.php"
                                                ?>

                                                <tr onclick="newShowModal('<?= $app['app_id'] ?>')"
                                                    style="cursor: pointer;">

                                                    <td>Заявление <?= $app['username'] ?> №<?= $app['app_id'] ?></td>
                                                    <td><?= $app['date_protokol'] ?></td>


                                                </tr>
                                                <?php
                                            }
                                            ?>

                                            </tbody>

                                        </table>


                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>



                <div class="tab-content tab-transparent-content">
                    <div class="tab-pane fade" id="accredArchiveNew" role="tabpanel" aria-labelledby="accredArchiveNew-tab">
                        <div class="row">
                            <div class="col-12 grid-margin">
                                <div class="card">
                                    <div class="card-body">

                                        <?php
                                        $query = "SELECT * FROM users where login = '$login'";

                                        $rez = mysqli_query($con, $query) or die("Ошибка " . mysqli_error($con));
                                        if (mysqli_num_rows($rez) == 1) //если нашлась одна строка, значит такой юзер существует в базе данных
                                        {
                                            $row = mysqli_fetch_assoc($rez);
                                            $role = $row['id_role'];
                                        }
                                        if ($role > 3 && $role < 12) {
                                            $query = "SELECT a.*, uz.username, uz.oblast, ram.*, a.id_application as app_id, r.date_protokol
                                                    FROM applications a
                                                   left outer join report_application_mark ram on a.id_application=ram.id_application
                                                    left outer join uz uz on uz.id_uz=a.id_user
                                                    left outer join rkk r on r.id_application=a.id_application
                                                   where id_status = 9 and u.oblast = '$role'";
                                        } else {
                                            $query = "SELECT a.*, uz.username, ram.*, a.id_application as app_id, r.date_protokol
                                FROM applications a
                               left outer join report_application_mark ram on a.id_application=ram.id_application
                               left outer join uz uz on uz.id_uz=a.id_user
                               left outer join rkk r on r.id_application=a.id_application
                        
                               -- left outer join users u on uz.id_uz =u.id_uz 
                                where -- uz.oblast='$oblast' and id_status = 9
					(('$id_role'=12 and (id_status = 9)) or ('$id_role'=14 and (id_status = 9) and  (uz.oblast='$oblast'))) 
					";
                                        }
                                        $result = mysqli_query($con, $query) or die (mysqli_error($con));
                                        for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row) ;
                                        ?>

                                        <table id="example" class="table table-striped table-bordered"
                                               style="width:100%">
                                            <thead>
                                            <tr>
                                                <th >Заявления</th>
                                                <th>Дата протокола</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <?php

                                            foreach ($data as $app) {
                                                include "ajax/mainMark.php"
                                                ?>

                                                <tr <?= $app['checkboxValueGuzo'] == "1" ? "style='font-weight: 900;'" : ""?> onclick="newShowModal('<?= $app['app_id'] ?>')"
                                                                                                                              style="cursor: pointer;">

                                                    <td>Заявление <?= $app['username'] ?> №<?= $app['app_id'] ?></td>
                                                    <td><?= $app['date_protokol'] ?></td>


                                                </tr>
                                                <?php
                                            }
                                            ?>

                                            </tbody>

                                        </table>


                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>


            </div>
        </div>
    </div>
    <div class="modal" id="myModal">
        <div class="modal-dialog modal-lg" style="max-width: none; margin: 0;">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <div style="display: flex">
                        <h4 class="modal-title">Создание заявления</h4>
                        <h4 id="id_application" style="margin-left: 5px"></h4>
                    </div>

                    <div style="display: flex">
                        <div style="margin-right: 1rem; margin-top: 10px;">
                            <h5 style="display: contents;" id="timeLeftSession"></h5>
                        </div>

                        <button type="button" class="btn  btn-danger btn-close  closeX" data-bs-dismiss="modal">x
                        </button>
                    </div>
                </div>

                <!-- Modal body -->
                <div class="modal-body">


                    <div class="col-md-12">
                        <div class="d-sm-flex justify-content-between align-items-center transaparent-tab-border ">
                            <ul class="nav nav-tabs tab-transparent" role="tablist" id="tablist">
                                <li class="nav-item" id="tab1" onclick="showTab(this)">
                                    <button class="nav-link active" data-toggle="tab" href="#" role="tab"
                                            aria-selected="true" id="button1" ;>Общие сведения о заявителе
                                    </button>
                                </li>


                                <!--                            ...-->
                            </ul>
                            <div class="d-md-block d-none">
                                <!--                            <a href="#" class="text-light p-1"><i class="mdi mdi-view-dashboard"></i></a>-->
                                <!--                            <a href="#" class="text-light p-1"><i class="mdi mdi-dots-vertical"></i></a>-->
                            </div>
                        </div>
                        <div class="tab-content tab-transparent-content">
                            <div class="tab-pane fade show active" id="tab1-" role="tabpanel"
                                 aria-labelledby="business-tab">

                                <div class="row">
                                    <div class="col-6 grid-margin">
                                        <div class="card">
                                            <div class="card-body">

                                                <div class="form-group"><label>Наименование юридического
                                                        лица</label><input id="naim" type="text" class="form-control"/>
                                                </div>
                                                <div class="form-group"><label>Сокращенное наименование</label><input
                                                            class="form-control" id="sokr" type="text"/></div>
                                                <div class="form-group"><label>УНП</label><input class="form-control"
                                                                                                 type="text" id="unp"
                                                                                                 onfocusout="onInputUnp()"/>
                                                </div>
                                                <div class="form-group"><label>Юридический адрес</label><input
                                                            class="form-control" type="text" id="adress"
                                                            onfocusout="onInputAdress()"/></div>
                                                <div class="form-group"><label>Фактический адрес</label><input
                                                            class="form-control" type="text" id="adressFact"
                                                            onfocusout="onInputAdressFact()"/></div>
                                                <div class="form-group"><label>Номер телефона</label><input
                                                            class="form-control" id="tel" type="text"/></div>
                                                <div class="form-group"><label>Электронная почта</label><input
                                                            class="form-control" type="email" id="email"
                                                            onfocusout="onInputEmail()"/></div>
                                                <div class="form-group">
                                                    <select name="" id="lico" onchange="chengeLico(this)">
                                                        <option value="0">Выбрать ответственное лицо</option>
                                                        <option value="1">Руководитель</option>
                                                        <option value="2">Представитель</option>
                                                    </select>
                                                </div>
                                                <div id="rukDiv" class="form-group hiddentab">
                                                    <label>Руководитель</label><input class="form-control" type="text"
                                                                                      id="rukovoditel"
                                                                                      placeholder="Должность, ФИО"/>
                                                </div>
                                                <div id="predDiv" class="form-group hiddentab">
                                                    <label>Представитель</label><input class="form-control" type="text"
                                                                                       id="predstavitel"
                                                                                       placeholder="Должность, ФИО"/>
                                                </div>
                                                <form id="formDoverennost">
                                                    <div class="form-group" id="divDoverennost">
                                                        <label for="doverennost">Доверенность</label>
                                                        <input type="file" class="form-control-file" name="doverennost"
                                                               id="doverennost" content="">
                                                    </div>
                                                </form>
                                                <form id="formPrikazNaznach">
                                                    <div class="form-group" id="divPrikazNaznach">
                                                        <label for="prikazNaznach">Приказ о назначении
                                                            руководителя</label>
                                                        <input type="file" class="form-control-file"
                                                               name="prikazNaznach" id="prikazNaznach" content="">
                                                    </div>
                                                </form>
                                                <br/>
                                                <!--                                            <form id="formDoverennost" method="post" class="hiddentab">-->
                                                <!--                                                <div class="form-group" id="divDoverennost">-->
                                                <!--                                                    <label for="doverennost">Доверенность</label>-->
                                                <!--                                                    <input type="file" name="doverennost" class="form-control-file" id="doverennost">-->
                                                <!--                                                </div>-->
                                                <!--                                            </form>-->


                                                <button class="btn-inverse-info hiddentab" onclick="newAddTab()" id="addtab">+
                                                    добавить подразделение
                                                </button>
                                                <br/>
                                                <br/>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 grid-margin">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="form-group"><label style="font-size: 18px">Обязательные
                                                        документы</label></div>

                                                <form id="formSoprovodPismo">
                                                    <div class="form-group" id="divSoprovodPismo">
                                                        <label for="soprPismo">Сопроводительное письмо</label>
                                                        <input type="file" class="form-control-file" name="Name"
                                                               id="soprPismo" content="">
                                                    </div>
                                                </form>

                                                <form id="formCopyRaspisanie">
                                                    <div class="form-group" id="divCopyRaspisanie">
                                                        <label for="copyRaspisanie">Копия штатного расписания</label>
                                                        <input type="file" class="form-control-file" name="Name"
                                                               id="copyRaspisanie">
                                                    </div>
                                                </form>

                                                <form id="formOrgStrukt">
                                                    <div class="form-group" id="divOrgStrukt">
                                                        <label for="orgStrukt">Организационная структура</label>
                                                        <input type="file" class="form-control-file" id="orgStrukt">
                                                    </div>
                                                </form>

                                                <form id="formUcomplect">
                                                    <div class="form-group" id="divUcomplect">
                                                        <label for="ucomplect">Укомплектованность</label>
                                                        <input type="file" class="form-control-file" id="ucomplect">
                                                    </div>
                                                </form>

                                                <form id="formTechOsn">
                                                    <div class="form-group" id="divTechOsn">
                                                        <label for="techOsn">Техническое оснащение</label>
                                                        <input type="file" class="form-control-file" id="techOsn">
                                                    </div>
                                                </form>

                                                <form id="formFileReportSamoocenka">
                                                    <div class="form-group " id="divFileReportSamoocenka">
                                                        <label for="reportSamoocenka">Результат самооценки</label>
                                                        <input type="file" class="form-control-file"
                                                               id="reportSamoocenka">
                                                    </div>
                                                </form>

                                                <form id="formFileReportZakluchenieSootvet">
                                                    <div class="form-group " id="divFileReportZakluchenieSootvet">
                                                        <label for="reportZakluchenieSootvet">Заключение о соответствии
                                                            помещений государственных организаций здравоохранения и
                                                            созданных в них условий требованиям законодательства в
                                                            области санитарно-эпидемиологического благополучия
                                                            населения</label>
                                                        <input type="file" class="form-control-file"
                                                               id="reportZakluchenieSootvet">
                                                    </div>
                                                </form>





                                                <form id="formFileReportDorabotka">
                                                    <div class="form-group " id="divFileReportDorabotka"
                                                         style="margin-bottom: 0px;">
                                                        <label for="reportDorabotka">Информация о необходимости
                                                            доработки</label>
                                                    </div>
                                                </form>
                                                <br>
                                                <form id="formDateDorabotka">
                                                    <div class="form-group " id="divDateDorabotka"
                                                         style="margin-bottom: 0px;">
                                                        <label for="dateDorabotka">Срок доработки</label>
                                                    </div>
                                                </form>
                                                <br>
                                            </div>
                                            <div class="card-body" id="mainRightCard">

                                            </div>

<!--                       --><?php //if ($role == "14"){
                        ?>

                                            <form id="formAdminResh">
                                                <div class="form-group" id="divAdminResh" style="margin-left: 2.5rem">
                                                    <label for="" style="font-size: 24px">Административное решение</label><br/>
                                                    <input type="file"  class="form-control-file"
                                                           id="fileAdminResh" multiple>
                                                </div>
                                                <div id="filesContainerAdminResh" style="margin-left: 50px;  margin-top: -15px;"></div>
                                            </form>

                           <form id="formReport">
                               <div class="form-group" id="divReport" style="margin-left: 2.5rem">
                                   <label for="" style="font-size: 24px">Отчет</label><br/>
                                   <input type="file"  class="form-control-file"
                                          id="fileReport" multiple>
                               </div>
                               <div id="filesContainer" style="margin-left: 50px;  margin-top: -15px;"></div>
                           </form>

                                            <form id="formPlan">
                                                <div class="form-group" id="divPlan" style="margin-left: 2.5rem">
                                                    <label for="" style="font-size: 24px">План по устранению недостатков</label><br/>
                                                    <input type="file" style="display: none"  class="form-control-file"
                                                           id="fileReport" multiple>
                                                </div>
                                                <div id="filesContainerPlan" style="margin-left: 50px;  margin-top: -15px;"></div>
                                            </form>

                                            <form id="formDataPlan">
                                                <div class="form-group" id="divDataPlan" style="margin-left: 2.5rem">
                                                    <label for="" style="font-size: 24px">Дата утверждения плана</label><br/>
                                                    <input style="display: none" type="file"  class="form-control-file"
                                                           id="fileReport" multiple>
                                                </div>
                                                <div id="filesContainerDataPlan" style="margin-left: 50px;  margin-top: -15px;"></div>
                                            </form>


                                            <form id="formZayavOtzyv">
                                                <div class="form-group" id="divZayavOtzyv" style="margin-left: 2.5rem">
                                                    <label for="" style="font-size: 24px">Заявление об отзыве</label><br/>
                                                    <input type="file" style="display: none"  class="form-control-file"
                                                           id="fileZayavOtzyv" multiple>
                                                </div>
                                                <div id="filesContainerZayavOtzyv" style="margin-left: 50px;  margin-top: -15px;"></div>
                                            </form>

                                            <form id="formDataZayavOtzyv">
                                                <div class="form-group" id="divDataZayavOtzyv" style="margin-left: 2.5rem">
                                                    <label for="" style="font-size: 24px">Планируемая дата повторной подачи</label><br/>
                                                    <input style="display: none" type="file"  class="form-control-file"
                                                           id="fileDataZayavOtzyv" multiple>
                                                </div>
                                                <div id="filesContainerDataZayavOtzyv" style="margin-left: 50px;  margin-top: -15px;"></div>
                                            </form>

<!--                        --><?php //}?>

                                        </div>
                                    </div>
                                    <!--                                <div style="width: 100%">-->
                                    <!--                                    <div style="display:flex; justify-content: flex-end;">-->
                                    <!--                                        <button type="submit" class="btn btn-warning btn-fw" id="btnSuc" >Сохранить</button>-->
                                    <!--                                    </div>-->
                                    <!--                                </div>-->

                                </div>

                            </div>


                        </div>
                    </div>


                </div>
                <!-- Modal footer -->
                <div class="modal-footer">
                    <!--                <form action="getApplication.php" method="post">-->
                    <!--                    <input type="text" name="count" id="count"/>-->
                    <!--                <p id="btnSuc" style="cursor: pointer">Загрузить данные</p>-->

                    <!-- <button type="submit" class="btn btn-success btn-fw" id="btnSend">Отправить</button> -->
                    <?php
                    if($id_role == "12"){ ?>
                    <button type="button" class="btn btn-danger btn-fw"  data-bs-dismiss="modal"
                            onclick="deleteApp()">Удалить заявление
                    </button>
                    <?php } ?>
                    <button type="submit" class="btn btn-success btn-fw hiddentab" id="btnOk">Завершить оценку</button>
                    <button type="submit" class="btn btn-success btn-fw" id="btnJournalActions">Журнал событий</button>
                    <button type="submit" class="btn btn-light btn-fw" id="btnFormApplication">Форма заявления</button>
                    <button data-tooltip="Печать критериев" type="submit" class="btn btn-light btn-fw" id="newBtnPrint">
                        Печать
                    </button>
                    <button type="submit" class="btn btn-light btn-fw" id="btnPrintReportOcenka">Отчет по оценке
                    </button>
                    <button type="submit" class="btn btn-light btn-fw" id="btnPrintReport">Отчет о самоаккредитации
                    </button>
                    <!--                <button type="submit" class="btn btn-light btn-fw" id="btnCalc">Рассчитать самооценку</button>-->

                    <!--                </form>-->
                    <button type="button" class="btn btn-danger closeD" data-bs-dismiss="modal">Закрыть</button>


                </div>

            </div>
        </div>
    </div>


    <div class="modal" id="modalUcomplect">
        <div class="modal-dialog " style="max-width: 80vw;">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <div style="display: flex">
                        <h4 class="modal-title">Укомплектованность</h4>
                    </div>

                    <div style="display: flex">


                        <button type="button" class="btn  btn-danger btn-close  closeXucomplect"
                                data-bs-dismiss="modal">x
                        </button>
                    </div>
                </div>

                <!-- Modal body -->
                <div class="modal-body">


                </div>

                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-light btn-fw" id="printUcomp" data-bs-dismiss="modal"
                            onclick="printModalContent()">Печать
                    </button>



                    <button type="button" class="btn btn-danger closeUcomplect" data-bs-dismiss="modal">Закрыть</button>
                </div>

            </div>
        </div>
    </div>


    <div id="journal">

    </div>

    <script>
        $(document).ready(function () {
            $('#examplet').DataTable({
                "searching": true,

                paging: false

                // false to disable search (or any other option)
            });
            //$('.dataTables_length').addClass('bs-select');
        });
    </script>
    <script src = "/dist/js/add_history_action.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <!--<script>--><?php //include 'getApplication.php' ?><!--</script>-->
    <!--<script>console.log(filesName)</script>-->
    <script src="/support/application/formApplication.js"></script>
<!--    <script src="/support/application/newFormApplication.js"></script>-->
    <script src="support/journals/journal/journal.js"></script>


    <script>

    </script>

<?php } else { ?>
    <div class="content-wrapper">
        <div class="row" id="proBanner">
            <div class="col-12">
                <!--    -->
            </div>
        </div>
        <div class="d-xl-flex justify-content-between align-items-start">
            <h2 class="text-dark font-weight-bold mb-2"> Требуется авторизация </h2>
        </div>
    </div>

<?php } ?>


