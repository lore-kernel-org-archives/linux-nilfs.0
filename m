From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Revert system state to snapshot
Date: Fri, 4 Oct 2013 18:41:28 +0400
Message-ID: <CAFPMYnFyrFd_rZwpAi+udSiwmf+ThDBFgZ0qBbEMBookOTyQVg@mail.gmail.com>
References: <CADV-EXEQUt9uP1xeDuMOQ-Qx-ghrvPwdMZL3a8G65e9ndiyeZw@mail.gmail.com>
	<1380892017.2413.13.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=x4V6OR3A5UFGfyR2AbGoFGpkLJhCzO6/99mNlmWIF/o=;
        b=fUg/araxq16U1YXs9TD72kATYlyNnAacC9LIsFMgZDSVsrflfMasab01USE+c3b60f
         80ZjhkooCJh7ixB8QUUOVrZHWMdh4t+Mv8gURI0vRNoLshuIuWAFlTuouhBAP0P1Xju0
         RDsE3fa4UhkBgEzYVM4eddq+SQUO4zFpKyEEXOzwuTPxIhQlS8pCR4qWuvC/UhQug1Ey
         Beb6lTLzHzY7wgShj3UFGnrCyn9FoJ4nCRUSdU5YgNvujq98NuARkJTmNneqcYGviwuA
         cq+wW/aplxKh88HD+gTRODwwBn/ZCVzo7zHwvtsWiCM65bdaY+wsnkk1eoBHkE6og9eJ
         ClhQ==
In-Reply-To: <1380892017.2413.13.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Yevhen Kyriukha <kirgene-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Personally for me, it will be great to an utility like this(supporting
the current utility conventions):
rvcp cp | ss [device] checkpoint-number
This should only work on an unmounted partition(else error), cp type
should be the one set by user (sp | ss),
The question should be asked that the operation will make all the data
written after this cp (cp date here) will be unrecoverably lost
continue any way?[yes/no], requiring full answer.
After this the FS should be in the state described by this cp and can
be mounted rw. All cps after given should be eliminated including ss
cps.

The use case is reverting system state(even the rootfs with the help
of live cd or live usb) to the previously made ss or existing cp
without any need of having another hdd, coping data from ro mounted cp
to the drive and than copying it back. This should ease FS modifying
related experiments greatly.

Thanks,
Aleksandrov Sergey

--------------------------------------------------
=E1=CC=C5=CB=D3=C1=CE=C4=D2=CF=D7 =F3=C5=D2=C7=C5=CA =F7=C1=D3=C9=CC=D8=
=C5=D7=C9=DE


2013/10/4 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> Hi Yevhen,
>
> On Fri, 2013-10-04 at 15:28 +0300, Yevhen Kyriukha wrote:
>> Hi!
>>
>> I'm wondering how can revert to snapshot by mounting file system as
>> writable in this state.
>>
>> I know that NILFS2 currently doesn't support this feature, but I thi=
nk
>> that implementation of such functionality is highly desirable.
>> Is there any date or estimates when this feature will be implemented=
?
>>
>
> If you would like to implement this feature then it will be great
> contribution to the NILFS2 project. You are welcome.
>
> Also it can be valuable your vision of this feature. Could you descri=
be
> what you expect from this feature and how you want to use it? A user'=
s
> vision is different from developer's vision very frequently.
>
> As far as I can judge, we haven't any implementation activity in this
> direction. If I am not fully informed then Ryusuke corrects me.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
