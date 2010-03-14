From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Sun, 14 Mar 2010 23:28:38 +0900 (JST)
Message-ID: <20100314.232838.05854811.ryusuke@osrg.net>
References: <hSSjxhQnnRB5.kxy725KN@mail.prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <hSSjxhQnnRB5.kxy725KN-GG6YVgmNXeLOQU1ULcgDhA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 14 Mar 2010 14:00:19 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> Hi,
> 
> I will try to implement this myself then. Concerning the
> nilfs_cleanerd_select segments function I was unclear in my post. In
> fact I did not mean the return value but the first element from the
> segnums array.

Ok. So you thought of determining termination of one cleaning pass by
the segment number stored preliminarily.

Why not just use count of processed (i.e. reclaimed) segments?

Note that it's not guranteed that segments are selected in the order
of segment number though this premise looks almost right.

It depends on the behavior of segment allocator and the current
"Select-oldest" algorithm used behind
nilfs_cleanerd_select_segments().  Nilfs log writer occasionally
behaves differently and disturbs this order.

I think you can ignore the exceptional behavior of the segment
allocator, and rotate target segments with skipping free or mostly
in-use ones.  In that case, nilfs_cleanerd_select_segments() should be
modified to select segments in the order of segment number.

Cheers,
Ryusuke Konishi

> Bye,
> David Arendt
> 
> -original message-
> Subject: Re: cleaner: run one cleaning pass based on minimum free space
> From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> Date: 14/03/2010 12:59
> 
> Hi,
> On Sun, 14 Mar 2010 09:47:55 +0100, David Arendt wrote:
> > Hi,
> > 
> > In order to avoid working both at the same thing, do you think about
> > implementing this yourself in near future or do you prefer that I try
> > implementing it myself and send you a patch ?
> 
> I'd appreciate it if you try it yourself.  I cannot commit time to
> this at least for a few weeks.
> 
> > For the case where you prefer that I try implementing it, here a quick
> > information in natural language how I would implement this in order to
> > see if I am thinking it correctly (line beginning with *** are changed):
> > 
> > 1166 /**
> > 1167  * nilfs_cleanerd_clean_loop - main loop of the cleaner daemon
> > 1168  * @cleanerd: cleanerd object
> > 1169  */
> > 1170 static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
> > 1171 {
> > 1172         struct nilfs_sustat sustat;
> > 1173         __u64 prev_nongc_ctime = 0, prottime = 0, oldest = 0;
> > 1174         __u64 segnums[NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX];
> > 
> > ***            _u64 previousfirstsegnum = max value of _u64;
> > 
> > 1175         struct timespec timeout;
> > 1176         sigset_t sigset;
> > 1177         int ns, ret;
> > 1178
> > 1179         sigemptyset(&sigset);
> > 1180         if (sigprocmask(SIG_SETMASK, &sigset, NULL) < 0) {
> > 1181                 syslog(LOG_ERR, "cannot set signal mask: %m");
> > 1182                 return -1;
> > 1183         }
> > 1184         sigaddset(&sigset, SIGHUP);
> > 1185
> > 1186         if (set_sigterm_handler() < 0) {
> > 1187                 syslog(LOG_ERR, "cannot set SIGTERM signal handler:
> > %m");
> > 1188                 return -1;
> > 1189         }
> > 1190         if (set_sighup_handler() < 0) {
> > 1191                 syslog(LOG_ERR, "cannot set SIGHUP signal handler:
> > %m");
> > 1192                 return -1;
> > 1193         }
> > 1194
> > 1195         nilfs_cleanerd_reload_config = 0;
> > 1196
> > 1197         ret = nilfs_cleanerd_init_interval(cleanerd);
> > 1198         if (ret < 0)
> > 1199                 return -1;
> > 1200
> > 1201         cleanerd->c_running = 1;
> > 1202         cleanerd->c_ncleansegs =
> > cleanerd->c_config.cf_nsegments_per_clean;
> > 1203
> > 1204         while (1) {
> > 1205                 if (sigprocmask(SIG_BLOCK, &sigset, NULL) < 0) {
> > 1206                         syslog(LOG_ERR, "cannot set signal mask: %m");
> > 1207                         return -1;
> > 1208                 }
> > 1209
> > 1210                 if (nilfs_cleanerd_reload_config) {
> > 1211                         if (nilfs_cleanerd_reconfig(cleanerd)) {
> > 1212                                 syslog(LOG_ERR, "cannot configure:
> > %m");
> > 1213                                 return -1;
> > 1214                         }
> > 1215                         nilfs_cleanerd_reload_config = 0;
> > 1216                         syslog(LOG_INFO, "configuration file
> > reloaded");
> > 1217                 }
> > 1218
> > 1219                 if (nilfs_get_sustat(cleanerd->c_nilfs, &sustat) < 0) {
> > 1220                         syslog(LOG_ERR, "cannot get segment usage
> > stat: %m");
> > 1221                         return -1;
> > 1222                 }
> > 1223                 if (sustat.ss_nongc_ctime != prev_nongc_ctime) {
> > 1224                         cleanerd->c_running = 1;
> > 1225                         prev_nongc_ctime = sustat.ss_nongc_ctime;
> > 1226                 }
> > 1227                 if (!cleanerd->c_running)
> > 1228                         goto sleep;
> > 1229
> > 1230                 syslog(LOG_DEBUG, "ncleansegs = %llu",
> > 1231                        (unsigned long long)sustat.ss_ncleansegs);
> > 1232
> > 1233                 ns = nilfs_cleanerd_select_segments(
> > 1234                         cleanerd, &sustat, segnums, &prottime,
> > &oldest);
> > 1235                 if (ns < 0) {
> > 1236                         syslog(LOG_ERR, "cannot select segments: %m");
> > 1237                         return -1;
> > 1238                 }
> > 
> > ***                    if ((in_configfile_defined_treshold > 0) &&
> > (segnums[0] < previousfirstsegnum)) // one full pass finished or first pass
> >                          {
> >                             if more than in_configfile_defined_treshold
> > space available (defined in configfile)
> >                             {
> >                                set timout to
> > in_configfile_definied_checktime secs;
> >                                goto sleep;
> >                             }
> >                          }
> > 
> >                          previousfirstsegum = segnums[0];
> > 
> > 1239                 syslog(LOG_DEBUG, "%d segment%s selected to be
> > cleaned",
> > 1240                        ns, (ns <= 1) ? "" : "s");
> > 1241                 if (ns > 0) {
> > 1242                         ret = nilfs_cleanerd_clean_segments(
> > 1243                                 cleanerd, &sustat, segnums, ns,
> > prottime);
> > 1244                         if (ret < 0)
> > 1245                                 return -1;
> > 1246                 }
> > 1247
> > 1248                 ret = nilfs_cleanerd_recalc_interval(
> > 1249                         cleanerd, ns, prottime, oldest, &timeout);
> > 1250                 if (ret < 0)
> > 1251                         return -1;
> > 1252                 else if (ret > 0)
> > 1253                         continue;
> > 1254  sleep:
> > 1255                 if (sigprocmask(SIG_UNBLOCK, &sigset, NULL) < 0) {
> > 1256                         syslog(LOG_ERR, "cannot set signal mask: %m");
> > 1257                         return -1;
> > 1258                 }
> > 1259
> > 1260                 ret = nilfs_cleanerd_sleep(cleanerd, &timeout);
> > 1261                 if (ret < 0)
> > 1262                         return -1;
> > 1263         }
> > 1264 }
> > 
> > I suppose that calling nilfs_get_sustat and
> > nilfs_cleanerd_select_segments without actually cleaning wouldn't cause
> > problems
> 
> Yes, this is correct.
> 
> > and nilfs_cleanerd_select_segments would always return the
> > first segment equal or less than the one from last call
> > or am I wrong with this ?
> 
> Seems misunderstanding.
> 
> nilfs_cleanerd_select_segments returns the number of selected segments
> for a shot of cleaning; if you set nsegments_per_clean = 2, this
> function returns equal or less than two.
> 
> > Is there a nilfs specific function I should use to determine the
> > free space available or should I use statfs ?
> 
> Actually, the free space reported by statfs is calculated from the
> number of free segments.  So it's internally equivalent.
> 
> You can refer to sustat.ss_ncleansegs for the number of free segments
> and sustat.ss_nsegs for the total number of segments.  I think
> nilfs_get_sustat() is appropriate for your purpose because it's
> already used in the loop function.
> 
> > Thanks in advance,
> > Bye,
> > David Arendt
> 
> With regards,
> Ryusuke Konishi
> 
>  
> > On 03/14/10 06:26, Ryusuke Konishi wrote:
> > > Hi,
> > > On Sat, 13 Mar 2010 21:49:43 +0100, David Arendt wrote:
> > >   
> > >> Hi,
> > >>
> > >> In order to reduce cleaner io, I am thinking it could be usefull to
> > >> implement a parameter where you can specify the minimum free space. If
> > >> this parameter is set, instead of normal cleaning operation, the cleaner
> > >> would wait until there is less than minimum free space available and
> > >> then run one cleaning pass (from first to last segment). If after that,
> > >> there is again more than minimum free space available, continue waiting,
> > >> otherwise run cleaning passes until there is more than minimum free
> > >> space available.
> > >>
> > >> What would you think about this idea ?
> > >>
> > >> Bye,
> > >> David Arendt
> > >>     
> > > Well, I think this is one of what cleaner should take in.  It can
> > > prevent cleanerd from moving in-use blocks too often unless the actual
> > > free space is less than the threshold.
> > >
> > > It may be the first thing to do since it's not difficult in principle.
> > >
> > > I recognize there are more fundamental defects in the current cleaner:
> > >
> > >  * It moves blocks in selected segments even if all of their blocks
> > >    are in-use.
> > >
> > >  * It doesn't give priority to reclaiming segments which have many
> > >    obsolete blocks.
> > >
> > >  * It keeps working without considering io workload of the time.
> > >
> > > But, I'd rather take a quick fix like your proposal.
> > >
> > > Regards,
> > > Ryusuke Konishi
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
