From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_count and blocks_count fields in nilfs_root struct
Date: Sat, 25 May 2013 02:01:04 +0400
Message-ID: <9EFBFA22-976F-4478-9B78-701B5A498E23@dubeyko.com>
References: <1369402372.2235.23.camel@slavad-ubuntu> <20130524175406.GD30270@logfs.org> <C2E05418-7137-46A8-AEC9-0E6A10F42669@dubeyko.com> <20130524190146.GF30270@logfs.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=Mb/khUuKSnuQZZvIiOpWBq8ESEBYXh0XpdtIWGQ+fqE=;
	b=XX2AUEuc1VDgzfbqtf+wNw5ur7YBy2qbQDen5YqaCYCB66NFc08TJjpVbEAuD1z7xYiXHv9AD87sJlTeANHogvzlAETe1EnSbu/Ebt2CFcMQqw8qSIX9L7398H4YtmjM;
In-Reply-To: <20130524190146.GF30270-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?J=F6rn_Engel?= <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


On May 24, 2013, at 11:01 PM, J=F6rn Engel wrote:

> On Fri, 24 May 2013 23:30:10 +0400, Vyacheslav Dubeyko wrote:
>> On May 24, 2013, at 9:54 PM, J=F6rn Engel wrote:
>>> On Fri, 24 May 2013 17:32:52 +0400, Vyacheslav Dubeyko wrote:
>>>>=20
>>>> Subject: [PATCH v5 2/2] nilfs2: use atomic_long_t type for inodes_=
count
>>> ...
>>>> The cp_inodes_count and cp_blocks_count are represented as
>>>> __le64 type in on-disk structure (struct nilfs_checkpoint).
>>>=20
>>> Isn't atomic_long_t defined to be 32bit on 32bit architectures?
>>=20
>> As I understand, yes.
>=20
> And it doesn't concern you to use a 32bit memory structure to
> represent a 64bit on-disk structure? ;)
>=20

I suppose that you mean possibility to mount NILFS2 volume under 32 bit=
 architecture
after working with this volume under 64 bit architecture. Am I correct?

Have you any concrete remarks about code of the patch? Feel free to off=
er your vision.

Thanks,
Vyacheslav Dubeyko.

> J=F6rn
>=20
> --
> Measure. Don't tune for speed until you've measured, and even then
> don't unless one part of the code overwhelms the rest.
> -- Rob Pike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
