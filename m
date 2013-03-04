From: Piter Dias <piter.dias-dmjmWuXPryWakBO8gow8eQ@public.gmane.org>
Subject: Re: Could someone share his experience with Samba and
 =?UTF-8?Q?NILFS=3F?=
Date: Sun, 03 Mar 2013 23:07:53 -0300
Message-ID: <047b0d2a94c9e784ca59f7bdacd1a036@piterdias.com>
References: <f3924e57f7fc9be324620e2fdc930e3f@piterdias.com>
 <1362117419.2088.5.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362117419.2088.5.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav,

Hi.

Well... It seems to be newbie error.
I started a smb.conf from scratch using webmin and now NILFS2 is 
accessible and writable for Windows users.

The "Previous versions", however, is empty. It is based on Samba shadow 
copy module. Am I doing something wrong below? "nilfs" shares is a whole 
NILFS2 disk.

[global]
	read raw = no
	hosts deny = ALL
	interfaces = eth0
	write raw = no
	hosts allow = 192.168.7.2

[homes]
	writeable = yes

[backup]
	path = /backup

[nilfs]
	valid users = piterdias
	writeable = yes
	path = /snapshoot
	vfs objects = shadow_copy2


On 2013-03-01 02:56, Vyacheslav Dubeyko wrote:
> Hi Piter,
> On Fri, 2013-03-01 at 00:26 -0300, Piter Dias wrote:
>> Hi.
>> I am using NILFS for few days, testing it to replace a /home 
>> partition
>> (currently ext3).
>> Although etx3 folders are easily available to my Windows machines, 
>> the
>> NILFS folders don't. It shows on Windows explorer but it says that 
>> the
>> network resource is not reachable.
>> 
> I guess that you should have error messages in your system log. Do you
> have it? Could you share NILFS2-related messages in your system log?
> I think that you can encounter an NILFS2 issue. But it needs to have
> more details about the reported issue's environment for the
> understanding of situation on your side.
> Thanks,
> Vyacheslav Dubeyko.
> 
>> Could someone share his experience with Samba and NILFS?
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" 
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
________________________
Piter Dias
piter.dias-dmjmWuXPryWakBO8gow8eQ@public.gmane.org
www.piterdias.com
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
