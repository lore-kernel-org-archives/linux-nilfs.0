From: santhosh kumars <karuna.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS development contribution
Date: Wed, 25 Apr 2012 11:18:41 +0530
Message-ID: <CABECqUFm=7V7keg5PJYetJim+O=f7k5UByJF_nbEpKCauY3kxA@mail.gmail.com>
References: <CABECqUEGCxizjgZPWUazTJBZYWTUTCQnbieDSaSUMj8oGeMnEQ@mail.gmail.com>
	<20120422.181504.62372140.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=mmhi5RnAt/AYNjFzIfp5W5QLtxW/wu0/j0s9My8ovK8=;
        b=f0DWkAxa76aFB6iUNUROsp6Uh0harOMVmyoMPK8iUZw54XIhHDCEI3ozivPXxv3gMo
         OvraV5iF+jbdUNDbavWXrla4Yr2DgUVp43vw+UufpgC3dyuQp6vREeRpNGdjPi79wwrk
         yHUIa/HpPBxHqYG/p21UcrKS1pkSnZU8CM8+CEQUczxauha+On9MAiDmDDwGfRXPjy42
         7O0Bz6SQNXgD3imsdnkOBl+pz6NXrfUAbP76Y5uNNt5NOYhqvXJw1YS733ag+92CeGLU
         pZs5AKU+GyiHJgAUT6tSF9tccLjzrJDXwdEOlPWxauHmLQVtNdh2cb7iQuHF3sxWiHF3
         jSCg==
In-Reply-To: <20120422.181504.62372140.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Apr 22, 2012 at 2:45 PM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> Hi,
> On Wed, 18 Apr 2012 16:35:28 +0530, santhosh kumars wrote:
>> Hi,
>> I have gone through the documents of NILFS mentioned on the home pag=
e
>> of NILFS. I have interest in file system development and have some
>> background knowledge about the linux VFS layer and have also created=
 a
>> sample memory based file system which resides only in the memory. In
>> one of the slides "Development of a New Logstructured File System fo=
r
>> Linux", there is a mention to involve outside developers in the
>> project as well. I too want to contribute in the development of nilf=
s
>> so I wanted to know where can I start from to get involved in the
>> project.can any one help me for =A0to get start please.
>>
>> Thanks,
>> karuanakar.
>
> Sorry for my late reply. I was quite busy this week.
>
>
> Contribution to our project is of course welcome.
>
> NILFS is now a part of the Linux kernel, and is developed using publi=
c
> git trees and the linux-nilfs mailing list. =A0I am taking in functio=
n
> enhancement as well as bug fixes which outside developers sent to me,
> simlilarly with usual Linux/OSS development.
>
> My recommendation for starting to get involved in the project is to
> utilize github; both userland utilities and nilfs branch of kernel
> tree are maintained there.
>
> This project has many todo items, which is listed in lower part of
> http://www.nilfs.org/en/current_status.html
>
> My recent concern is improving garbage collection algorithm and I/O
> performance of in-kernel filesystem module.
>
> What is necessary is just to do your favorite or possible thing,
> however, if you can provide help to these priorities, I would
> appreciate it :)
>
>
> Thanks,
> Ryusuke Konishi

hi  Ryusuke Konishi
Thanks for your mail and information. First of all I would like to
work on  fixing bugs.
Just i want to know where can i find the list of bugs, so that i can
move forward.
thanks for your reply.
thanks,
Karunakar.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
