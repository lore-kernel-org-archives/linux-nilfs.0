From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Mon, 11 May 2009 09:57:49 +0900 (JST)
Message-ID: <20090511.095749.62039741.ryusuke@osrg.net>
References: <4A06D0C4.5030008@prnet.org>
	<20090511.004002.32775441.ryusuke@osrg.net>
	<4A06FCEB.7030800@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A06FCEB.7030800-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Sun, 10 May 2009 18:12:27 +0200, David Arendt wrote:
> >>> I finally gave up trailing this problem from your log because my gcc
> >>> generates different assembler code with yours.
> >>>
> >>> Could you send me a disassembler output of the nilfs_gc_iget function?
> >>> It is acquirable as follows:
> >>>
> >>>   $ cd nilfs2-module/fs
> >>>   $ objdump -D gcinode.o > gcinode.disasm
>
> Hi,
> 
> ok, here the requested file
> 
> Bye,
> David Arendt

Thanks!

I could identify the instruction which caused the fault.

Regards,
Ryusuke Konishi
