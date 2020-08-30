$(function () {
    var speed = 600, autoTime = 5000;
    var movePX, ind, len, timer;
    window.onresize = function () {
        window.clearTimeout(timer);
        nav_init();
        timer = window.setTimeout(function () { autoMove(); }, autoTime);
    }
    function nav_init() {
        movePX = $('.photoShow').width(),
        ind = $('.photoShow .current').index('.photoShow li'),
        len = $('#photoShow li').length;
        this.navObj = $('#nav');
        this.ul = $('.photoShow ul');
        this.li = $('.photoShow ul li');
        this.ind_nav = $('#nav .ehover').index('#nav em');
        //this.parentWidth = this.navObj.parent().width();
        this.parentWidth = this.navObj.parent().width();
        this.left = (this.parentWidth - this.navObj.width()) / 2;
        this.navObj.css({'left': this.left});
        this.ul.css({ width: movePX * len + 'px','marginLeft': -movePX * ind+'px' });
        this.li.css({ width: movePX  + 'px' });
    }
    function nav_change(next) {
        $('#nav em').removeClass('ehover').eq(next).addClass('ehover');
    }
    function moveTo(to) {
        var gotoIt;
        ind = $('.photoShow .current').index('.photoShow li');
        //console.log('当前: ' + ind);
        if ((to == '' || to == null || to == 'undefined') && to != 0) {
        	gotoIt = ind < len - 1 ? ind + 1 : 0;
        } else {
            console.log('选择:' + to);
            gotoIt = to < 0 ? len - 1 : to > len - 1 ? 0 : to;
        }
        //console.log('下个: ' + goto);
        //console.log('--------------------');
        $('.photoShow li').removeClass('current').eq(gotoIt).addClass('current');
        $('#photoShow').animate({ 'marginLeft': -movePX * gotoIt }, speed);
        nav_change(gotoIt);
    }
    function autoMove() {
        moveTo();
        timer = window.setTimeout(function () { autoMove(); }, autoTime);
    }
    nav_init();
    timer = window.setTimeout(function () { autoMove(); }, autoTime);


    $('#left').click(function () {
        ind = $('.photoShow .current').index('.photoShow li'); moveTo(ind - 1);
    });
    $('#right').click(function () {
        ind = $('.photoShow .current').index('.photoShow li'); moveTo(ind + 1);
    });
    $('#nav em').click(function () {
        var ind_nav = $(this).index('#nav em'); moveTo(ind_nav);
    });
    $('.photoShow').mouseover(function () { window.clearTimeout(timer); }).mouseout(function () { timer = window.setTimeout(function () { autoMove(); }, autoTime); });
});