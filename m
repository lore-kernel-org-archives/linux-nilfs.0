From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: nilfs-utils in Fedora now
Date: Mon, 03 Aug 2009 13:03:51 -0500
Message-ID: <4A772687.4040704@redhat.com>
References: <4A722B66.7010006@redhat.com>
	<20090804.025321.12536090.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090804.025321.12536090.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke Konishi wrote:
> Hi,
> On Thu, 30 Jul 2009 18:23:18 -0500, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> I have nilfs-utils in Fedora now, for F11 and rawhide.  It'll take a
>> little while for things to get out to the repos, but if anyone is using
>> nilfs on Fedora, hopefully this'll make things a little easier or
>> convenient.
>>
>> For F11 it's headed to the testing repo, for now.
>>
>> Thanks,
>> -Eric
> 
> Thank you for letting us know this!  I hope your work really helps
> nilfs users of fedora to make things easy hereafter.
> 
> BTW, is there any plan on adding the kernel code of nilfs to extra
> packages for fedora 12 or the later?

Do you mean like a kmod rpm for updated nilfs kernel code that is not
yet upstream?  No, Fedora doesn't allow kmods in the official
repositories.  But nilfs is already configured on in F11 and F12, so
nilfs.ko is already there in the kernel rpm.

Or maybe I misunderstand you question?

-Eric

> Thanks,
> Ryusuke Konishi
