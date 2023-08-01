<style>
    .card {
        position: relative;
        display: -ms-flexbox;
        display: flex;
        -ms-flex-direction: column;
        flex-direction: column;
        min-width: 0;
        word-wrap: break-word;
        background-color: #fff;
        background-clip: border-box;
        border: 0 solid rgba(0, 0, 0, 0.125);
        border-radius: 0.25rem;
    }
    .direct-chat-messages {
        -webkit-transform: translate(0, 0);
        transform: translate(0, 0);
        overflow: auto;
        padding: 10px;
    }
    .direct-chat-infos {
        display: block;
        font-size: 0.875rem;
        margin-bottom: 2px;
    }
    .direct-chat-name {
        font-weight: 600;
    }
    .float-left {
        float: left !important;
    }
    .direct-chat-msg {
        margin-bottom: 10px;
    }

    .direct-chat-msg, .direct-chat-text {
        display: block;
    }
    .direct-chat-text {
        border-radius: 0.3rem;
        background-color: #d2d6de;
        border: 1px solid #d2d6de;
        color: #444;
        margin: 5px 0 0 1rem;
        padding: 5px 10px;
        position: relative;
    }
    .card .card-body {
         padding: 1rem;
    }
    .direct-chat-infos {
        display: block;
        font-size: 0.875rem;
        margin-bottom: 2px;
    }
    .content-wrapper {
        background: #f0f1f6;
        padding: 0.875rem 2.875rem 0 2.875rem;
        width: 100%;
        -webkit-box-flex: 1;
        -ms-flex-positive: 1;
        flex-grow: 1;
    }
    .container-fluid1{
        width: 50%;
        padding-right: 9px;
        padding-left: 9px;
        margin-right: auto;
        margin-left: 0;
    }
    @media (max-width: 800px) {
        .container-fluid1{
            width: 100%;
            padding-right: 9px;
            padding-left: 9px;
            margin-right: auto;
            margin-left: 0;
        }
    }

    .question{
        padding: 5px 20px;
        border-bottom: 1px solid #d1d1d1;
        max-width: 100%;
        margin-bottom: 10px;
        width: 100%;
        text-align: left;
        font-size: 19px;
        font-weight: 600;
    }
    /*.question span {*/
    /*    float: left;*/
    /*    font-size: 14px;*/
    /*    display: flex;*/
    /*    align-items: center;*/
    /*    justify-content: center;*/
    /*    border: 1px solid;*/
    /*    width: 30px;*/
    /*    height: 30px;*/
    /*}*/
    .content1 {
        text-align: left;
        font-size: 14px;
        font-weight: 300;
        display:none
    }

    .file-block {
        display: inline-block;
        width: 18%;
        margin: 10px;
        height: 99px;
    }

    .file-link {
        text-decoration: none;
        color: #333;
    }

    .file-link:hover {
        color: #0099ff;
    }

    .file-icon {
        width: 50px;
        height: 50px;
    }

    .file-name {
        display: block;
        margin-top: 5px;
    }
    .col-lg-2{
        margin-left: 2rem
    }
    @media (max-width: 800px) {
        .col-lg-2{
            margin-left: 0rem;
        }
    }
</style>
<div class="content-wrapper">
    <h2 for="quastion" style = "margin-top: 1rem">Полезные документы</h2><br/>
    <div class="row" >
        <div class="col-lg-2">
            <a href="documentation/Руководство пользователя (ОЗ) к ИС Медицинская аккредитации.docx" class="file-link">
                <img src="assets/images/word-icon.png" alt="Word" class="file-icon">
                <span class="file-name">Руководство пользователя (ОЗ) к ИС Медицинская аккредитации</span>
            </a>
        </div>

        <div class="col-lg-2" >
            <a href="documentation/Сопроводительное письмо образец.docx" class="file-link">
                <img src="assets/images/word-icon.png" alt="PDF" class="file-icon">
                <span class="file-name">Сопроводительное письмо образец</span>
            </a>
        </div>

        <div class="col-lg-2">
            <a href="documentation/Информация об используемой медицинской технике.docx" class="file-link">
                <img src="assets/images/word-icon.png" alt="PDF" class="file-icon">
                <span class="file-name">Информация об используемой медицинской технике</span>
            </a>
        </div>

        <div class="col-lg-2">
            <a href="documentation/Показатели укомплектованности.docx" class="file-link">
                <img src="assets/images/word-icon.png" alt="PDF" class="file-icon">
                <span class="file-name">Показатели укомплектованности</span>
            </a>
        </div>

        <div class="col-lg-2" >
            <a href="documentation/Схема_организационной_структуры_ОЗ_образец.pptx" class="file-link">
                <img src="assets/images/pptx-icon.png" alt="PDF" class="file-icon">
                <span class="file-name">Схема организационной структуры ОЗ образец</span>
            </a>
        </div>
    </div>
    <section class="content">


        <div class="card direct-chat direct-chat-primary" style="height: 500px;margin-top: 2rem">

            <div class="card direct-chat direct-chat-primary" style="height: 700px">
                <div class="card-header" style="background-color: #148A8A; color: white; height: 3rem">
                    <h3 class="card-title" style=" color: white;">Часто задаваемые вопросы</h3>

                </div>
            <!-- /.card-header -->
            <div class="card-body">
                <!-- Conversations are loaded here -->
                <?php
                $query = "SELECT * FROM `questions` where important  = 1";
                $result=mysqli_query($con, $query) or die ( mysqli_error($con));
                for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row);
                foreach ($data as $app) {
                ?>
                <div class="faq">
                    <div class="question" style="cursor: pointer">
                        <p><?= $app['id_question']?>. <span>   <?= $app['question']?></span></p>
                        <div class="content1"><?= $app['answer']?></div>
                    </div>
                </div>
                <?php } ?>

            </div>
            </div>
        </div>
    </section>

    <div class="container-fluid1">
        <!-- Small boxes (Stat box) -->
        <!-- /.row -->
        <!-- Main row -->

        <?php if (isset($_COOKIE['login'])) { ?>
            <h2 for="quastion" style = "margin-top: 2rem">Задать вопрос</h2><br/>
            <textarea name="" id="question"  rows="7" style="width: 100%;"></textarea><br/>
            <button type="submit" class="btn btn-success btn-fw" id="btnQuestion">Отправить</button>
        <?php }?>
    </div>
</div>



<script>
    function getCookie(cname) {
        let name = cname + "=";
        let decodedCookie = decodeURIComponent(document.cookie);
        let ca = decodedCookie.split(';');
        for(let i = 0; i <ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }

    let txtArea = document.getElementById("question");
    $("#btnQuestion").on("click", () => {
        $.ajax({
            url: "sendQuestion.php",
            method: "GET",
            data: {id_user: getCookie('id_user'), question: txtArea.value}
        })
            .done(function( response ) {
                alert("Ваш вопрос отправлен.");
                location.href = "index.php?help";
            });
    });

      let itemMenu = document.querySelector("[href='help.php']");
      itemMenu.style = "color: #148A8A;";

</script>

<script>
    $('.question').click(function() {
        $(this).find('.content1').toggle(200); //скрытие, показ ответа
        $(this).find('span').css('transform', 'rotate(0deg)'); //поворот стрелки
        if ($(this).hasClass('open')) {
            $(this).removeClass('open');
        } else {
            $(this).addClass('open');
            $(this).find('span').css('transform', 'rotate(180deg)'); //поворот стрелки
        };
    });
</script>