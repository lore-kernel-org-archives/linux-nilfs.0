From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: FS corruption bug(?) and tools bug in 2.0.11
Date: Tue, 17 Mar 2009 15:13:51 +0900 (JST)
Message-ID: <20090317.151351.02395807.ryusuke@osrg.net>
References: <200903170040.08486.ahartmetz@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200903170040.08486.ahartmetz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, ahartmetz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, 17 Mar 2009 00:40:08 +0100, Andreas Hartmetz wrote:
> I'll copy and paste my notes on that here in the hope that you can help.
> 
> # mkfs.nilfs2 -c /dev/sdc1
> mkfs.nilfs2 ver 2.0
> Internal error: command line buffer overflow
> 
> # mkfs.nilfs2 -qc /dev/sdc1
> <no output, seems to work.>
> 
> the command only takes about three seconds to complete so it can't possibly
> have checked the whole 8 gigabyte flash card, i.e. it did not seem to respect
> the -c option.

Thank you for reporting these problems.  I pushed their fixes to the
git repository of nilfs2-utils.

FS corruption problem is still under investigation.
Sorry for inconvenience.

Regards,
Ryusuke Konsihi
