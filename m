From: John Huttley <John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
Subject: Re: Snapshot and mount scripts
Date: Thu, 16 Oct 2008 10:33:53 +1300
Message-ID: <48F661C1.5030105@mib-infotech.co.nz>
References: <48F3C04B.7000300@mib-infotech.co.nz>	<20081015.152427.73215105.ryusuke@osrg.net>	<48F59E90.9060404@mib-infotech.co.nz>
	<20081015.232356.82122358.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081015.232356.82122358.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Hi Ryusuke,

Ryusuke Konishi wrote:
<snip>
> Actually, the primitive version of nilfs2 had a support of the
> ``anonymous'' snapshot mount but it was disabled before the first
> formal release.
>
> Users could mount snapshots just with a readonly option as follows:
>
>  # mount -t nilfs2 /dev/sdb1 /nilfs
>  ...
>  # mount -t nilfs2 -r /dev/sdb1 /backup
>
> And this was convenient for (consistent) online backup as you say.
> Unfortunately, NILFSv2 cannot do this due to race problems of GC.
> (It is possible on NILFS version 1, which does not have GC).
>
> If you like this anonymous snapshot mount, I'll try to bring it back.
>
>   

I'm sure that would be a very useful feature!

Regards,

john

> With regards,
> Ryusuke Konishi
>
>
>   
