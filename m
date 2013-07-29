From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Mon, 29 Jul 2013 21:30:23 +0400
Message-ID: <0755E1EF-36D0-42F0-A2FB-B312D717DC2C@dubeyko.com>
References: <CALJXSJquK6YxGKuH97Ec2CTMyJaZrJjOfePSKtgPDm8_9YXzzw@mail.gmail.com> <CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q@mail.gmail.com> <F4156394-8A25-4F81-81C3-9921CB00BD92@dubeyko.com> <CALJXSJrj0J_-ZUCOurJXaYhx_wEJwxb2_5OOJjQSSmmP-PQDgg@mail.gmail.com> <1374578141.2226.5.camel@slavad-ubuntu> <CALJXSJrY22eGkYA76wwL4moAdsjV+_PUtvVO6tt5K16hzMh8xQ@mail.gmail.com> <680DC2BF-EEEC-445C-BA5B-DF966CABF1BA@dubeyko.com> <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=WVvRMQK9lQiR8vxHZHVnnVUoctP0G/UXKpASNvIgg2A=;
	b=K+iaYmtcSUicoAEetWDAS+v0U6xdkqo3IfIv568O/8KW3nLkq0NLwjmmYEmgGmrog9+Oz/h/OcovPvwsU9DjEIdU+2QsueTM08NsHi2UEfRUathpmehT1tS6AuzB69pW;
In-Reply-To: <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


On Jul 27, 2013, at 10:05 PM, J=E9r=F4me Poulin wrote:

> On Sat, Jul 27, 2013 at 1:06 PM, Vyacheslav Dubeyko <slava-yeENwD64cLyIwRZHo2/mJg@public.gmane.org=
m> wrote:
>> I tried to reproduce the issue but I haven't success in it.
>> Could you describe the reproducing path in more details?
>>=20
>=20
> Since I have a reproducible path, here is how I did:
> 1. init S to get to single user mode.
> 2. sysrq+E to make sure only my shell is running
> 3. start network-manager to get my wifi connection up
> 4. login as root and launch "screen"
> 5. cd /boot/log/nilfs which is a ext3 mount point and can log when NI=
LFS dies.
> 6. lscp | xz -9e > lscp.txt.xz
> 7. mount my snapshot using mount -o cp=3D3360839,ro /dev/vgUbuntu/roo=
t /mnt/nilfs
> 8. start a screen to dump /proc/kmsg to text file since rsyslog is ki=
lled
> 9. start a screen and launch strace -f -o find-cat.log -t find
> /mnt/nilfs -type f -exec cat {} > /dev/null \;
> 10. start a screen and launch strace -f -o apt-get.log -t apt-get upd=
ate
> 11. launch the last command again as it did not crash the first time
> 12. apt-get crashes
> 13. ps aux > ps-aux-crashed.log
> 13. sysrq+W
> 14. sysrq+E  wait for everything to terminate
> 15. sysrq+SUSB
>=20

I have reproduced the issue successfully. So, I can begin to investigat=
e it.

Thank you for efforts in the issue reproducing and detailed information
about the issue.

With the bets regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
