From: karunakar merugu <karuna.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: fsck.nilfs2: not found
Date: Thu, 10 May 2012 11:15:16 +0530
Message-ID: <CABECqUFcaLJ_yvHQCotvUj1X4yvDSL3hCwt4U0SNhuELYXddVw@mail.gmail.com>
References: <CABECqUHJFN-6K1eP29BL39G=EgSTf2usRHLAWsNY98zzMTLT7w@mail.gmail.com>
	<F4C68CD6-CB84-4F60-88D2-8AB0DB9A17AA@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=3hri52bRHLtfEWQNgfMFZZ7NSq5scvQdRWQKWeYB1hk=;
        b=mgYsyxrKUp5fAmIx4o80UeccPzd/+b6r0GnlycSd1L+57rD6f5R2lvO3589wlx4UU7
         Bnnj4wSW5Q1TbCZSNwvofB2ZRhWB14QExTugAbqailCrutTVgIPiINo1z/0Eb4JRw6m0
         8UTD11AtEeT1RHV4z4KAmEy3JsYsm7PQzsf/n1mKJVuyUhEoWWBY2PyyLpz0JzTx+BFW
         MCSD2GN1ovmOQi1spw77wZ806y5YVMQnO4zgnvC/zaPYX933zTZ4HMhmk1TALlfdYq/u
         jxnGmyK1xZLtPp5sa8PH9lxqmKAUFPTqFFuahbaiUHEPwBOFLSO/7YQ3BFKECyd0LCaN
         dtIQ==
In-Reply-To: <F4C68CD6-CB84-4F60-88D2-8AB0DB9A17AA-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hi
I am trying to test xfstests on nilfs.During this i got this error
fsck.nilfs2 not found.
Is any one tried xfstests for nilfs and facing same problem ?
thanks,
karunakar.

On Wed, May 9, 2012 at 4:51 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> =
wrote:
> Hi,
>
> Sorry, but as I know fsck tool for NILFS filesystem doesn't implement=
ed yet.
>
> With the best regards,
> Vyacheslav Dubeyko.
>
> On May 9, 2012, at 1:16 PM, karunakar merugu wrote:
>
>> Hi
>> I am using Linux karunakar-VirtualBox 3.0.0-12-generic #20-Ubuntu SM=
P.
>> I installed nilfs utilities =A0by
>> sudo apt-get update
>> sudo apt-get install nilfs2-tools
>>
>> Even after this I am getting error like:
>> fsck from util-linux 2.19.1
>> fsck: fsck.nilfs2: not found
>> fsck: Error 2 while executing fsck.nilfs2 for /dev/sdb
>>
>> can anyone help me in finding the correct package for fsck.nilfs2
>> utility please.
>> thanks,
>> Karunakar.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
