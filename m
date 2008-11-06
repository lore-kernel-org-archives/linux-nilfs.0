From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd
Date: Thu, 06 Nov 2008 11:50:07 +0900 (JST)
Message-ID: <20081106.115007.82106068.ryusuke@osrg.net>
References: <491213E2.4010905@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <491213E2.4010905-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org

Hi,

On Thu, 06 Nov 2008 10:45:06 +1300, John Huttley wrote:
> Hi,
> my cleanerd stopped again, though I don't see anything in the logs
> 
> Is there a way of getting better logging for debugging purposes?
> 
> --John

Sorry for inconvenience.

To get better cleanerd logs, change log_priority level specified in
/etc/nilfs_cleanerd.conf as follows:

log_priority  info

       |
       v

log_priority  debug

This will make the cleanerd write debug information in syslog.

Note that a HUP signal must be sent to the cleanerd or doing
umount/mount the nilfs partition is required to reflect the change.


Then, if nilfs2 seems to hang during GC, please get a stack dump by
sending the following system request from an active terminal or
console.

 # echo t > /proc/sysrq-trigger

This will dump stack information of every kernel thread.  The stack
information that contains `nilfs' keywords would give the hint about
which function causes the hang problem.

With regards,
Ryusuke Konishi
