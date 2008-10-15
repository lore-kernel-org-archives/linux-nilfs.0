From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't remove a snapshot, operation not permitted.
Date: Wed, 15 Oct 2008 21:42:00 +0900 (JST)
Message-ID: <20081015.214200.33560052.ryusuke@osrg.net>
References: <48F59F4E.7040806@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <48F59F4E.7040806-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
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

Hi John,

On Wed, 15 Oct 2008 20:44:14 +1300, John Huttley wrote:
> Hi,
> 
> I'm using the kernel module from the web page,
> kernel 2.6.27
> X64
> nilfs-utils from git.
> 
> I can make lots of snapshots but can't delete any.
> 
> Any ideas??

rmcp cannot delete snapshots.
Did you change them to plain checkpoints before removal?

 # chcp cp <cno>
 # rmcp <cno>

Regards,
Ryusuke Konishi
