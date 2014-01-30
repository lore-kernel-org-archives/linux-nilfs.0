From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Thu, 30 Jan 2014 15:03:09 +0100
Message-ID: <CAFvQSYQ-qkXz677-obgHVN5fLQiF10-A=T2yNNAHKRcOGm_Pqw@mail.gmail.com>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	<20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	<1389866912.2565.44.camel@slavad-ubuntu>
	<20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
	<1390901114.2942.11.camel@slavad-ubuntu-12.04>
	<CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
	<71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com>
	<CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A@mail.gmail.com>
	<AE0F313D-5934-452B-80AB-5D691AF8A4BE@dubeyko.com>
	<CAFvQSYQGDXmUit1zFZ9_LAjdLjxM-i_yR2L6pwFDX_BEdjdXxQ@mail.gmail.com>
	<1391088759.2637.13.camel@ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=fnLnDdvjsxHUrFN5GVW31v4XTn3JFOLo9QcnvoZExCE=;
        b=hFbPV04MvC/5FzTXirs3VyCDDChrD3EbiQMeOqvVhnuBcDZY8DGAgLCZ9tkrfkxUqn
         BMyfUhmdDQqWIhp2c57yvrEXIUPmHq/mhJImF6ZAe+faepn2xHRPgya0gxD7jsn5kW+o
         igPWmsKRdeQFVI2SnjIvRepnJls/koKnTNCAMcj9dboXdhXgnoE+MxwDMEh3kncI1xio
         oyscfBGrqxdqUw8sPe0gmpfLUEJAZF+Hfl93Owe/1Ag9BEnU4ov/jK6ZH7ZseXoQTKY2
         zfqC6ntbmOzH6f4VM7pXQ88Hu1reUutEqnhoUTlN1o6Lm071k8L8V9HCsugTaU+Lj02t
         WBFQ==
In-Reply-To: <1391088759.2637.13.camel@ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

> The result of unclean shutdown and big update timeout will be a long
> mount. And such issue was reported earlier and it was fixed. I don't
> think that Andreas's patch can resolve long mount principally. Maybe
> this approach can slightly reduce mount time in such situation.

So even without Andreas' patch there is no risk for data loss with a
very outdated superblock - but recovery would be slower?

> In such case NILFS2 at whole is in trouble. Because partial segments can
> have different size. And these sizes doesn't correlate with sizes of
> physical erase block or physical writing units. And the whole COW
> approach is useless.

Sure, NILFS won't cure the horrible write-amplification of those
devices, but it will spread the wear evenly over the whole device
thanks to COW.
So it won`t wear out the meadia faster where it`s metadata is stored
(with exception of the superblock) like ext4 does.
Btw. isn't nilfs's minimal writing size 128kb (I remember I read it in
a paper somewhere)?

Regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
