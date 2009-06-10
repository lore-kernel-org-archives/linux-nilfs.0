From: "Nelson Sicuro" <nsicuro-i1oeJEPGGWo@public.gmane.org>
Subject: Re: New to NILFS2
Date: Wed, 10 Jun 2009 16:59:45 -0300
Message-ID: <op.uvbq5vn5bbxqew@sicuro>
References: <op.uvbisbbobbxqew@sicuro>
	<20090611.035006.76168843.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090611.035006.76168843.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Thanks for the tip, I compiled the tools and it worked, following the  
site's instructions. There is any directions to build the module?

Best regards,

Nelson Sicuro

> Hi!
> On Wed, 10 Jun 2009 13:58:49 -0300, "Nelson Sicuro" wrote:
>> Hi everyone
>>
>> I started using NILFS2 version 2.0.14 this month on Ubuntu 8.04 and
>> 8.10 distros (2.6.24-24-generic 64 bits), so far so good.
>>
>> I looked at the new's archives and find some interesting questions
>> about deleting more than one CP at a time. Can I use this feature on
>> my distro or do I need to recompile nilfs-tools? May this feature be
>> included on Ubuntu 9.04?
>
> Unfortunately I don't have contact with Ubuntu maintainers, so I
> cannot mention the release plan.
>
> But, yes, the CP deletion feature is available from our git repo.  The
> belief instruction is shown in the following page:
>
> http://www.nilfs.org/git/
>
> I also recommend you to apply the current head of nilfs2-module.git
> available if you use the git repo since it includes an important
> performance improvement patch.  Anyway, I'm planning to release both
> updates next week unless I'm busy.
>
>> Best regards and congrats for the excellent job!
>> Nelson Sicuro, from Brazil, Universidade Federal do Paran
>
> Cheers,
> Ryusuke Konishi
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
